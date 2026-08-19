if vim.g.loaded_keyseek then
  return
end
vim.g.loaded_keyseek = true

vim.api.nvim_create_user_command('Keyseek', function()
  require('keyseek').open()
end, { desc = 'Search all keymaps in a floating window' })
