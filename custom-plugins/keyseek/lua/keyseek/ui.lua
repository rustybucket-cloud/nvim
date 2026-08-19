-- Centered floating picker: a one-line prompt above a scrollable result list.
local collect = require 'keyseek.collect'

local M = {}

local ns = vim.api.nvim_create_namespace 'keyseek'
local MODE_FILTERS = { 'all', 'n', 'i', 'v', 'x', 's', 'o', 't', 'c' }

local state = nil

local function clamp(value, lo, hi)
  return math.max(lo, math.min(value, hi))
end

local function geometry(config)
  local cols, lines = vim.o.columns, vim.o.lines
  local width = clamp(math.floor(cols * config.width), 40, cols - 4)
  local height = clamp(math.floor(lines * config.height), 5, lines - 8)
  local total = height + 5 -- results + its border + prompt + prompt border
  local row = math.max(0, math.floor((lines - total) / 2))
  local col = math.max(0, math.floor((cols - width) / 2))
  return width, height, row, col
end

-- Column layout: mode | lhs | plugin | description.
local function columns(entry)
  return {
    { text = entry.mode, width = 3, hl = 'KeyseekMode' },
    { text = entry.lhs, width = state.lhs_width, hl = 'KeyseekKey' },
    { text = entry.plugin or '', width = state.plugin_width, hl = 'KeyseekPlugin' },
    { text = entry.desc or '', hl = nil },
  }
end

local function display(entry, _)
  local parts = {}
  for _, column in ipairs(columns(entry)) do
    local text = column.text
    if column.width then
      if #text > column.width then
        text = text:sub(1, column.width - 1) .. '~'
      end
      text = text .. string.rep(' ', column.width - #text)
    end
    parts[#parts + 1] = text
  end
  return (table.concat(parts, ' '):gsub('%s+$', ''))
end

local function filtered(query)
  local pool = {}
  for _, entry in ipairs(state.entries) do
    if state.mode_filter == 'all' or entry.mode == state.mode_filter then
      pool[#pool + 1] = entry
    end
  end

  if query == '' then
    local out = {}
    for _, entry in ipairs(pool) do
      out[#out + 1] = { entry = entry, positions = {} }
    end
    return out
  end

  local items = {}
  for i, entry in ipairs(pool) do
    items[i] = { text = display(entry, state.lhs_width), idx = i }
  end

  local matched, positions = unpack(vim.fn.matchfuzzypos(items, query, { key = 'text' }))
  local out = {}
  for i, item in ipairs(matched) do
    out[#out + 1] = { entry = pool[item.idx], positions = positions[i] or {} }
  end
  return out
end

local function set_footer(entry)
  if not (state and vim.api.nvim_win_is_valid(state.result_win)) then
    return
  end
  local text
  if not entry then
    text = ' no matches '
  else
    local parts = {}
    if entry.rhs ~= '' then
      parts[#parts + 1] = entry.rhs
    end
    if entry.source then
      parts[#parts + 1] = entry.source
    end
    if entry.buffer then
      parts[#parts + 1] = 'buffer-local'
    end
    text = ' ' .. (table.concat(parts, '  |  ')):sub(1, state.width - 4) .. ' '
  end
  pcall(vim.api.nvim_win_set_config, state.result_win, { footer = text, footer_pos = 'right' })
end

local function set_title()
  if not (state and vim.api.nvim_win_is_valid(state.prompt_win)) then
    return
  end
  local title = string.format(' Keymaps (%d)  mode: %s ', #state.matches, state.mode_filter)
  pcall(vim.api.nvim_win_set_config, state.prompt_win, { title = title, title_pos = 'center' })
end

local function render()
  local lines = {}
  for _, match in ipairs(state.matches) do
    lines[#lines + 1] = display(match.entry, state.lhs_width)
  end
  if #lines == 0 then
    lines = { '  no matching keymaps' }
  end

  vim.bo[state.result_buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.result_buf, 0, -1, false, lines)
  vim.bo[state.result_buf].modifiable = false

  vim.api.nvim_buf_clear_namespace(state.result_buf, ns, 0, -1)
  for row, match in ipairs(state.matches) do
    local line = lines[row]
    local col = 0
    for _, column in ipairs(columns(match.entry)) do
      local width = column.width or #column.text
      if column.hl and col < #line then
        pcall(vim.api.nvim_buf_set_extmark, state.result_buf, ns, row - 1, col, {
          end_col = math.min(col + math.min(#column.text, width), #line),
          hl_group = column.hl,
        })
      end
      col = col + width + 1
    end
    for _, pos in ipairs(match.positions) do
      if pos < #line then
        pcall(vim.api.nvim_buf_set_extmark, state.result_buf, ns, row - 1, pos, {
          end_col = pos + 1,
          hl_group = 'KeyseekMatch',
          priority = 200,
        })
      end
    end
  end

  state.selected = clamp(state.selected, 1, math.max(1, #state.matches))
  if vim.api.nvim_win_is_valid(state.result_win) then
    pcall(vim.api.nvim_win_set_cursor, state.result_win, { state.selected, 0 })
  end
  set_title()
  set_footer(state.matches[state.selected] and state.matches[state.selected].entry)
end

local function update()
  local query = vim.api.nvim_buf_get_lines(state.prompt_buf, 0, 1, false)[1] or ''
  state.query = query
  state.matches = filtered(query)
  state.selected = 1
  render()
end

local function move(delta)
  if #state.matches == 0 then
    return
  end
  state.selected = clamp(state.selected + delta, 1, #state.matches)
  pcall(vim.api.nvim_win_set_cursor, state.result_win, { state.selected, 0 })
  set_footer(state.matches[state.selected].entry)
end

function M.close()
  if not state then
    return
  end
  local current = state
  state = nil
  for _, win in ipairs { current.prompt_win, current.result_win } do
    if win and vim.api.nvim_win_is_valid(win) then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end
  for _, buf in ipairs { current.prompt_buf, current.result_buf } do
    if buf and vim.api.nvim_buf_is_valid(buf) then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end
  if current.origin_win and vim.api.nvim_win_is_valid(current.origin_win) then
    pcall(vim.api.nvim_set_current_win, current.origin_win)
  end
  return current
end

local function selected_entry()
  local match = state.matches[state.selected]
  return match and match.entry or nil
end

local function execute()
  local entry = selected_entry()
  if not entry then
    return
  end
  M.close()
  vim.schedule(function()
    if entry.mode == 'n' then
      vim.api.nvim_feedkeys(entry.raw, 'm', false)
    else
      vim.fn.setreg('"', entry.lhs)
      vim.notify(string.format('%s mode keymap %s yanked to " register', entry.mode, entry.lhs), vim.log.levels.INFO)
    end
  end)
end

local function yank()
  local entry = selected_entry()
  if not entry then
    return
  end
  M.close()
  vim.fn.setreg('+', entry.lhs)
  vim.fn.setreg('"', entry.lhs)
  vim.notify('Yanked ' .. entry.lhs, vim.log.levels.INFO)
end

local function cycle_mode()
  local current = 1
  for i, mode in ipairs(MODE_FILTERS) do
    if mode == state.mode_filter then
      current = i
    end
  end
  state.mode_filter = MODE_FILTERS[(current % #MODE_FILTERS) + 1]
  update()
end

local function map(buf, modes, lhs, fn)
  vim.keymap.set(modes, lhs, fn, { buffer = buf, nowait = true, silent = true })
end

function M.open(config)
  if state then
    M.close()
  end

  local origin_win = vim.api.nvim_get_current_win()
  local entries = collect.entries(vim.api.nvim_get_current_buf())

  local lhs_width, plugin_width = 10, 6
  for _, entry in ipairs(entries) do
    lhs_width = math.max(lhs_width, #entry.lhs)
    plugin_width = math.max(plugin_width, #(entry.plugin or ''))
  end
  lhs_width = math.min(lhs_width, 28)
  plugin_width = math.min(plugin_width, 20)

  local width, height, row, col = geometry(config)

  local prompt_buf = vim.api.nvim_create_buf(false, true)
  local result_buf = vim.api.nvim_create_buf(false, true)
  vim.bo[prompt_buf].bufhidden = 'wipe'
  vim.bo[result_buf].bufhidden = 'wipe'
  vim.bo[result_buf].modifiable = false
  vim.bo[prompt_buf].filetype = 'keyseek-prompt'
  vim.bo[result_buf].filetype = 'keyseek'

  local prompt_win = vim.api.nvim_open_win(prompt_buf, false, {
    relative = 'editor',
    width = width,
    height = 1,
    row = row + 1,
    col = col,
    style = 'minimal',
    border = config.border,
    title = ' Keymaps ',
    title_pos = 'center',
    zindex = 60,
  })

  local result_win = vim.api.nvim_open_win(result_buf, false, {
    relative = 'editor',
    width = width,
    height = height,
    row = row + 4,
    col = col,
    style = 'minimal',
    border = config.border,
    title = ' <CR> run  <C-y> yank  <C-t> mode  <Esc> close ',
    title_pos = 'center',
    zindex = 60,
  })

  vim.wo[result_win].cursorline = true
  vim.wo[result_win].winhighlight = 'Normal:KeyseekNormal,FloatBorder:KeyseekBorder,CursorLine:KeyseekSelection'
  vim.wo[prompt_win].winhighlight = 'Normal:KeyseekNormal,FloatBorder:KeyseekBorder'

  state = {
    entries = entries,
    matches = {},
    selected = 1,
    query = '',
    mode_filter = 'all',
    lhs_width = lhs_width,
    plugin_width = plugin_width,
    width = width,
    prompt_buf = prompt_buf,
    result_buf = result_buf,
    prompt_win = prompt_win,
    result_win = result_win,
    origin_win = origin_win,
  }

  map(prompt_buf, { 'i', 'n' }, '<Esc>', M.close)
  map(prompt_buf, 'n', 'q', M.close)
  map(prompt_buf, { 'i', 'n' }, '<C-c>', M.close)
  map(prompt_buf, { 'i', 'n' }, '<Down>', function() move(1) end)
  map(prompt_buf, { 'i', 'n' }, '<Up>', function() move(-1) end)
  map(prompt_buf, { 'i', 'n' }, '<C-n>', function() move(1) end)
  map(prompt_buf, { 'i', 'n' }, '<C-p>', function() move(-1) end)
  map(prompt_buf, { 'i', 'n' }, '<C-d>', function() move(math.floor(height / 2)) end)
  map(prompt_buf, { 'i', 'n' }, '<C-u>', function() move(-math.floor(height / 2)) end)
  map(prompt_buf, { 'i', 'n' }, '<CR>', execute)
  map(prompt_buf, { 'i', 'n' }, '<C-y>', yank)
  map(prompt_buf, { 'i', 'n' }, '<C-t>', cycle_mode)

  vim.api.nvim_create_autocmd({ 'TextChangedI', 'TextChanged' }, {
    buffer = prompt_buf,
    callback = function()
      if state then
        update()
      end
    end,
  })
  vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
    buffer = prompt_buf,
    once = true,
    callback = function()
      vim.schedule(function()
        if state and vim.api.nvim_get_current_win() ~= state.prompt_win then
          M.close()
        end
      end)
    end,
  })

  update()
  vim.api.nvim_set_current_win(prompt_win)
  vim.cmd.startinsert()
end

function M.toggle(config)
  if state then
    M.close()
  else
    M.open(config)
  end
end

return M
