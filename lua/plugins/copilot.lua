-- return {
--   'github/copilot.vim',
--   config = function()
--     vim.keymap.set('i', '<C-j>', 'copilot#Accept("\\<CR>")', {
--       expr = true,
--       replace_keycodes = false,
--     })
--     vim.g.copilot_no_tab_map = true
--     vim.keymap.set('i', '<C-L>', '<Plug>(copilot-accept-word)')
--   end,
-- }
--
return {
  'zbirenbaum/copilot.lua',
  dependencies = {
    'copilotlsp-nvim/copilot-lsp', -- (optional) for NES functionality
  },
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      nes = {
        enabled = true,
        keymap = {
          accept_and_goto = '<leader>j',
          dismiss = '<Esc>',
        },
      },
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = '[[',
          jump_next = ']]',
          accept = '<CR>',
          refresh = 'gr',
          open = '<M-CR>',
        },
        layout = {
          position = 'bottom', -- | top | left | right | bottom |
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        trigger_on_accept = true,
        keymap = {
          accept = '<C-j>',
          accept_word = false,
          accept_line = false,
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-]>',
        },
      },
    }
  end,
}
