--Floaterm: a floating terminal plugin for Vim and Neovim

local floatterm_open = 0

local function floaterm_open()
  floatterm_open = 1
  vim.cmd 'FloatermToggle'
end

local function floaterm_close()
  if floatterm_open == 1 then
    vim.cmd 'FloatermToggle'
    floatterm_open = 0
  end
end

local function floaterm_new()
  if floatterm_open == 1 then
    vim.cmd 'FloatermNew'
  end
end

local function floaterm_kill()
  if floatterm_open == 1 then
    vim.cmd 'FloatermKill'
    floatterm_open = 0
  end
end

local function floaterm_next()
  if floatterm_open == 1 then
    vim.cmd 'FloatermNext'
  end
end

local function floaterm_prev()
  if floatterm_open == 1 then
    vim.cmd 'FloatermPrev'
  end
end

return {
  'voldikss/vim-floaterm',
  config = function()
    vim.keymap.set('n', '<C-j>', floaterm_open, { desc = 'Toggle Floaterm', noremap = true })

    vim.keymap.set('t', '<C-j>', floaterm_close, { desc = 'Toggle Floaterm' })
    vim.keymap.set('t', '<C-n>', floaterm_new, { desc = 'New Floaterm' })
    vim.keymap.set('t', '<C-q>', floaterm_kill, { desc = 'Kill Floaterm' })
    vim.keymap.set('t', '<C-l>', floaterm_next, { desc = 'Next Floaterm' })
    vim.keymap.set('t', '<C-h>', floaterm_prev, { desc = 'Previous Floaterm' })
  end,
}
