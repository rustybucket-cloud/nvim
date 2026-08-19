-- Local plugin: searchable keymap browser in a centered float.
return {
  dir = vim.fn.stdpath 'config' .. '/custom-plugins/keyseek',
  name = 'keyseek',
  cmd = 'Keyseek',
  keys = {
    { '<leader>?', '<cmd>Keyseek<cr>', desc = 'Search Keymaps' },
    { '<leader>sK', '<cmd>Keyseek<cr>', desc = '[S]earch [K]eymaps (float)' },
  },
  opts = {
    width = 0.8,
    height = 0.6,
    border = 'rounded',
  },
}
