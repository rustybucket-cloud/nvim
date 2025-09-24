return {
  'easymotion/vim-easymotion',
  event = 'VeryLazy',
  config = function()
    vim.keymap.set('n', '<leader>ww', '<Plug>(easymotion-w)', { desc = 'Easymotion jump to [W]ord', noremap = false })
    vim.keymap.set('n', '<leader>wl', '<Plug>(easymotion-j)', { desc = 'Easymotion jump to [L]ine', noremap = false })
    vim.keymap.set('n', '<leader>wk', '<Plug>(easymotion-k)', { noremap = false })
    vim.keymap.set('n', '<leader>wh', '<Plug>(easymotion-h)', { noremap = false })
  end,
}
