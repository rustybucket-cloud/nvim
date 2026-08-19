-- keyseek: browse and fuzzy-search every keymap in a centered floating window.
local M = {}

local defaults = {
  width = 0.8, -- fraction of the editor
  height = 0.6, -- fraction of the editor (result list only)
  border = 'rounded',
}

M.config = vim.deepcopy(defaults)

local function highlights()
  local links = {
    KeyseekNormal = 'NormalFloat',
    KeyseekBorder = 'FloatBorder',
    KeyseekSelection = 'Visual',
    KeyseekMode = 'Comment',
    KeyseekKey = 'Identifier',
    KeyseekPlugin = 'Type',
    KeyseekMatch = 'Special',
  }
  for name, link in pairs(links) do
    vim.api.nvim_set_hl(0, name, { link = link, default = true })
  end
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', vim.deepcopy(defaults), opts or {})
  highlights()
  vim.api.nvim_create_autocmd('ColorScheme', { callback = highlights })
end

function M.open()
  require('keyseek.ui').open(M.config)
end

function M.close()
  require('keyseek.ui').close()
end

function M.toggle()
  require('keyseek.ui').toggle(M.config)
end

return M
