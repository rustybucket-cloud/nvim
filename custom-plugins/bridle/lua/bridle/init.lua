local M = {}

M.default_width = 0.5
M.resize_step = 10

M.opencode_cmd = "opencode --port"
M.opencode_terminal_opts = {
  win = { position = "right", width = M.default_width, enter = false },
}

local providers = { "claude", "opencode" }
local state_file = vim.fn.stdpath("state") .. "/ai_provider.txt"

local function read_provider()
  local f = io.open(state_file, "r")
  if not f then
    return providers[1]
  end
  local content = f:read("*l")
  f:close()
  if content == "claude" or content == "opencode" then
    return content
  end
  return providers[1]
end

local current = read_provider()

function M.get()
  return current
end

function M.set(provider)
  if provider ~= "claude" and provider ~= "opencode" then
    vim.notify("Unknown AI provider: " .. tostring(provider), vim.log.levels.ERROR)
    return
  end
  current = provider
  local f = io.open(state_file, "w")
  if f then
    f:write(provider)
    f:close()
  end
  vim.notify("AI provider: " .. provider)
end

local function opencode_win()
  local ok, win = pcall(function()
    return require("snacks.terminal").get(M.opencode_cmd, vim.tbl_extend("force", M.opencode_terminal_opts, {
      create = false,
    }))
  end)
  return ok and win or nil
end

---@return boolean visible whether the given provider currently has a visible window
function M.is_open(provider)
  if provider == "claude" then
    local ok, terminal = pcall(require, "claudecode.terminal")
    if not ok then
      return false
    end
    local bufnr = terminal.get_active_terminal_bufnr()
    if not bufnr then
      return false
    end
    return #vim.fn.win_findbuf(bufnr) > 0
  end
  local win = opencode_win()
  return win ~= nil and win:valid()
end

function M.close(provider)
  if provider == "claude" then
    pcall(vim.cmd, "ClaudeCodeClose")
  else
    local win = opencode_win()
    if win then
      win:hide()
    end
  end
end

function M.toggle_provider()
  local previous = current
  local was_open = M.is_open(previous)

  M.set(previous == "claude" and "opencode" or "claude")

  if was_open then
    M.close(previous)
    M.open()
  end
end

function M.open()
  if current == "claude" then
    vim.cmd("ClaudeCode")
  else
    require("snacks.terminal").toggle(M.opencode_cmd, M.opencode_terminal_opts)
  end
end

---@return integer? winid the window id of the currently open AI window, if any
local function current_winid()
  if current == "claude" then
    local ok, terminal = pcall(require, "claudecode.terminal")
    if not ok then
      return nil
    end
    local bufnr = terminal.get_active_terminal_bufnr()
    if not bufnr then
      return nil
    end
    return vim.fn.win_findbuf(bufnr)[1]
  end
  local win = opencode_win()
  return win and win:valid() and win.win or nil
end

---Grow or shrink the currently open AI window by the given number of columns.
---@param delta integer positive to grow, negative to shrink
function M.resize(delta)
  local win = current_winid()
  if not win then
    vim.notify("No AI window open to resize", vim.log.levels.WARN)
    return
  end
  vim.api.nvim_win_set_width(win, math.max(1, vim.api.nvim_win_get_width(win) + delta))
end

---Set the currently open AI window's width to a percentage of the editor width.
---@param pct number width as a fraction of vim.o.columns (e.g. 0.5 for 50%)
function M.resize_to(pct)
  local win = current_winid()
  if not win then
    vim.notify("No AI window open to resize", vim.log.levels.WARN)
    return
  end
  vim.api.nvim_win_set_width(win, math.max(1, math.floor(vim.o.columns * pct)))
end

return M
