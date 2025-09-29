-- Fugitive: a Git wrapper so awesome, it should be illegal

return {
  'tpope/vim-fugitive',
  event = 'VeryLazy',
  config = function()
    vim.keymap.set('n', '<leader>gd', ':Gvdiffsplit!<CR>', { desc = 'Git: Vertical Diff Split' })
    vim.keymap.set('n', '<leader>gb', ':Git blame!<CR>', { desc = 'Git: Vertical Diff Split' })
    vim.keymap.set('n', '<leader>gv', ':Git!<CR>', { desc = 'Git: Vertical Diff Split' })
    vim.keymap.set('n', '<leader>gs', ':Git status<CR>', { desc = 'Git: Vertical Diff Split' })
  end,
}
