-- Collects every keymap Neovim knows about, normalized for display.
local M = {}

M.modes = { 'n', 'i', 'v', 'x', 's', 'o', 't', 'c' }

local function leader_prefix()
  local leader = vim.g.mapleader
  if not leader or leader == '' then
    return nil
  end
  return vim.fn.keytrans(leader)
end

local function pretty_lhs(raw)
  -- `raw` holds real termcode bytes, so keytrans gives the canonical <C-x> form.
  local lhs = vim.fn.keytrans(raw)
  local leader = leader_prefix()
  if leader and #leader > 0 and lhs:sub(1, #leader) == leader then
    lhs = '<leader>' .. lhs:sub(#leader + 1)
  end
  return lhs
end

-- Absolute path of the file that defined a map, or nil.
local function path_of(map)
  if map.callback then
    local ok, info = pcall(debug.getinfo, map.callback, 'S')
    if ok and info and info.source and info.source:sub(1, 1) == '@' then
      return info.source:sub(2), info.linedefined
    end
    if ok and info and info.short_src and info.short_src ~= '[C]' then
      return info.short_src, info.linedefined
    end
  end
  -- Vimscript maps (and anything without a Lua callback) still carry a script id.
  if map.sid and map.sid > 0 then
    local info = vim.fn.getscriptinfo { sid = map.sid }
    if info and info[1] and info[1].name ~= '' then
      return info[1].name, map.lnum
    end
  end
  return nil
end

local function source_of(path, lnum)
  if not path then
    return nil
  end
  local src = vim.fn.fnamemodify(path, ':~')
  if lnum and lnum > 0 then
    src = src .. ':' .. lnum
  end
  return src
end

-- lazy.nvim registers placeholder maps for plugins it has not loaded yet; those
-- all point at lazy's own handler file, so ask lazy who really owns the key.
local function lazy_pending()
  local ok, handler = pcall(require, 'lazy.core.handler')
  if not ok then
    return {}
  end
  local keys = handler.handlers and handler.handlers.keys
  return (keys and keys.managed) or {}
end

local function plugin_from_path(path)
  if not path then
    return nil
  end
  path = path:gsub('\\', '/')
  local lazy_name = path:match '/lazy/([^/]+)/'
  if lazy_name then
    return lazy_name
  end
  local packed = path:match '/pack/[^/]+/[^/]+/([^/]+)/'
  if packed then
    return packed
  end
  local runtime = vim.env.VIMRUNTIME
  if path:match '^vim/' or (runtime and runtime ~= '' and path:sub(1, #runtime) == runtime) then
    return 'nvim'
  end
  local config = vim.fn.stdpath 'config'
  if path:sub(1, #config) == config then
    local rel = path:sub(#config + 2)
    return rel:match '^lua/plugins/(.+)%.lua$' or 'config'
  end
  return vim.fn.fnamemodify(path, ':t:r')
end

local function rhs_of(map)
  if map.rhs and map.rhs ~= '' then
    return (map.rhs:gsub('%s+', ' '))
  end
  if map.callback then
    return '<lua>'
  end
  return ''
end

---@param bufnr integer buffer whose local maps should be included
---@return table[] entries
function M.entries(bufnr)
  local seen, entries = {}, {}
  local pending = lazy_pending()

  local function add(map, is_buf)
    -- `lhsraw` (Neovim 0.10+) is the untranslated key sequence; `lhs` is already
    -- rendered for special keys, so translating it again would escape the '<'.
    local raw = map.lhsraw or vim.api.nvim_replace_termcodes(map.lhs or '', true, true, true)
    local mode = map.mode == ' ' and 'v' or map.mode
    local key = mode .. '\0' .. raw .. '\0' .. tostring(is_buf)
    if seen[key] then
      return
    end
    seen[key] = true
    local rhs = rhs_of(map)
    local path, lnum = path_of(map)
    local plugin = plugin_from_path(path)
    if not plugin or plugin == 'lazy.nvim' then
      plugin = pending[raw] or pending[raw .. ' (' .. mode .. ')'] or plugin
    end
    entries[#entries + 1] = {
      mode = mode,
      raw = raw,
      lhs = pretty_lhs(raw),
      plugin = plugin or '',
      desc = map.desc or rhs,
      rhs = rhs,
      buffer = is_buf,
      source = source_of(path, lnum),
    }
  end

  for _, mode in ipairs(M.modes) do
    for _, map in ipairs(vim.api.nvim_buf_get_keymap(bufnr, mode)) do
      add(map, true)
    end
    for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
      add(map, false)
    end
  end

  table.sort(entries, function(a, b)
    if a.lhs ~= b.lhs then
      return a.lhs:lower() < b.lhs:lower()
    end
    return a.mode < b.mode
  end)

  return entries
end

return M
