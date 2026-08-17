return {
  'LintaoAmons/scratch.nvim',
  event = 'VeryLazy',
  config = function()
    require('scratch').setup({
      scratch_file_dir = vim.fn.stdpath('data') .. '/scratch.nvim',
      filetypes = { 'lua', 'js', 'py', 'sh', 'txt', 'md' },
      filetype_details = {},
      window_cmd = 'edit',
      use_telescope = true,
    })

    vim.keymap.set('n', '<M-C-n>', '<cmd>Scratch<cr>')
    vim.keymap.set('n', '<M-C-o>', '<cmd>ScratchOpen<cr>')
  end,
}
