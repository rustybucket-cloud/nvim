return {
  'sudo-tee/opencode.nvim',
  config = function()
    -- Default configuration with all available options
    require('opencode').setup {
      preferred_picker = nil, -- 'telescope', 'fzf', 'mini.pick', 'snacks', if nil, it will use the best available picker
      prefered_completion = nil, -- 'blip', 'nvim-cmp','vim_complete' if nil, it will use the best available completion
      default_global_keymaps = true, -- If false, disables all default global keymaps
      default_mode = 'build', -- 'build' or 'plan' or any custom configured. @see [OpenCode Agents](https://opencode.ai/docs/modes/)
      config_file_path = nil, -- Path to opencode configuration file if different from the default `~/.config/opencode/config.json` or `~/.config/opencode/opencode.json`
      keymap = {
        global = {
          toggle = '<leader>oa', -- Open opencode. Close if opened
          open_input = '<leader>oi', -- Opens and focuses on input window on insert mode
          open_input_new_session = '<leader>oI', -- Opens and focuses on input window on insert mode. Creates a new session
          open_output = '<leader>oo', -- Opens and focuses on output window
          toggle_focus = '<leader>ot', -- Toggle focus between opencode and last window
          close = '<leader>oq', -- Close UI windows
          select_session = '<leader>os', -- Select and load a opencode session
          configure_provider = '<leader>op', -- Quick provider and model switch from predefined list
          diff_open = '<leader>od', -- Opens a diff tab of a modified file since the last opencode prompt
          diff_next = '<leader>o]', -- Navigate to next file diff
          diff_prev = '<leader>o[', -- Navigate to previous file diff
          diff_close = '<leader>oc', -- Close diff view tab and return to normal editing
          diff_revert_all_last_prompt = '<leader>ora', -- Revert all file changes since the last opencode prompt
          diff_revert_this_last_prompt = '<leader>ort', -- Revert current file changes since the last opencode prompt
          diff_revert_all = '<leader>orA', -- Revert all file changes since the last opencode session
          diff_revert_this = '<leader>orT', -- Revert current file changes since the last opencode session
          swap_position = '<leader>ox', -- Swap Opencode pane left/right
        },
        window = {
          submit = '<cr>', -- Submit prompt (normal mode)
          submit_insert = '<C-s>', -- Submit prompt (insert mode)
          close = '<esc>', -- Close UI windows
          stop = '<C-c>', -- Stop opencode while it is running
          next_message = ']]', -- Navigate to next message in the conversation
          prev_message = '[[', -- Navigate to previous message in the conversation
          mention_file = '@', -- Pick a file and add to context. See File Mentions section
          slash_command = '/', -- Pick a command to run in the input window
          toggle_pane = '<tab>', -- Toggle between input and output panes
          prev_prompt_history = '<up>', -- Navigate to previous prompt in history
          next_prompt_history = '<down>', -- Navigate to next prompt in history
          switch_mode = '<M-m>', -- Switch between modes (build/plan)
          focus_input = '<C-i>', -- Focus on input window and enter insert mode at the end of the input from the output window
          select_child_session = '<leader>oS', -- Select and load a child session
          debug_messages = '<leader>oD', -- Open raw message in new buffer for debugging
          debug_output = '<leader>oO', -- Open raw output in new buffer for debugging
        },
      },
      ui = {
        position = 'right', -- 'right' (default) or 'left'. Position of the UI split
        input_position = 'bottom', -- 'bottom' (default) or 'top'. Position of the input window
        window_width = 0.40, -- Width as percentage of editor width
        input_height = 0.15, -- Input height as percentage of window height
        display_model = true, -- Display model name on top winbar
        display_context_size = true, -- Display context size in the footer
        display_cost = true, -- Display cost in the footer
        window_highlight = 'Normal:OpencodeBackground,FloatBorder:OpencodeBorder', -- Highlight group for the opencode window
        icons = {
          preset = 'emoji', -- 'emoji' | 'text'. Choose UI icon style (default: 'emoji')
          overrides = {}, -- Optional per-key overrides, see section below
        },
        output = {
          tools = {
            show_output = true, -- Show tools output [diffs, cmd output, etc.] (default: true)
          },
        },
        input = {
          text = {
            wrap = true, -- Wraps text inside input window
          },
        },
        completion = {
          file_sources = {
            enabled = true,
            preferred_cli_tool = 'fd', -- 'fd','fdfind','rg','git' if nil, it will use the best available tool
            ignore_patterns = {
              '^%.git/',
              '^%.svn/',
              '^%.hg/',
              'node_modules/',
              '%.pyc$',
              '%.o$',
              '%.obj$',
              '%.exe$',
              '%.dll$',
              '%.so$',
              '%.dylib$',
              '%.class$',
              '%.jar$',
              '%.war$',
              '%.ear$',
              'target/',
              'build/',
              'dist/',
              'out/',
              'deps/',
              '%.tmp$',
              '%.temp$',
              '%.log$',
              '%.cache$',
            },
            max_files = 10,
            max_display_length = 50, -- Maximum length for file path display in completion, truncates from left with "..."
          },
        },
      },
      context = {
        enabled = true, -- Enable automatic context capturing
        cursor_data = {
          enabled = false, -- Include cursor position and line content in the context
        },
        diagnostics = {
          info = false, -- Include diagnostics info in the context (default to false
          warn = true, -- Include diagnostics warnings in the context
          error = true, -- Include diagnostics errors in the context
        },
        current_file = {
          enabled = true, -- Include current file path and content in the context
        },
        selection = {
          enabled = true, -- Include selected text in the context
        },
      },
      debug = {
        enabled = false, -- Enable debug messages in the output window
      },
    }
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        anti_conceal = { enabled = false },
        file_types = { 'markdown', 'opencode_output' },
      },
      ft = { 'markdown', 'Avante', 'copilot-chat', 'opencode_output' },
    },
    -- Optional, for file mentions and commands completion, pick only one
    'saghen/blink.cmp',
    -- 'hrsh7th/nvim-cmp',

    -- Optional, for file mentions picker, pick only one
    'folke/snacks.nvim',
    -- 'nvim-telescope/telescope.nvim',
    -- 'ibhagwan/fzf-lua',
    -- 'nvim_mini/mini.nvim',
  },
}

-- return {
--   -- 'NickvanDyke/opencode.nvim',
--   dir = '~/dev/opencode.nvim',
--   name = 'opencode.nvim',
--   dependencies = {
--     -- Recommended for better prompt input, and required to use `opencode.nvim`'s embedded terminal — otherwise optional
--     { 'folke/snacks.nvim', opts = { input = { enabled = true } } },
--   },
--   config = function()
--     vim.g.opencode_opts = {
--       -- Your configuration, if any — see `lua/opencode/config.lua`
--     }
--
--     -- Required for `opts.auto_reload`
--     vim.opt.autoread = true
--
--     -- Recommended keymaps
--     vim.keymap.set('n', '<C-o>', function()
--       require('opencode').toggle()
--     end, { desc = 'Toggle' })
--     vim.keymap.set('t', '<C-o>', function()
--       require('opencode').toggle()
--     end, { desc = 'Toggle' })
--     vim.keymap.set('n', '<leader>oA', function()
--       require('opencode').ask()
--     end, { desc = 'Ask' })
--     vim.keymap.set('n', '<leader>oa', function()
--       require('opencode').ask '@cursor: '
--     end, { desc = 'Ask about this' })
--     vim.keymap.set('v', '<leader>oa', function()
--       require('opencode').ask '@selection: '
--     end, { desc = 'Ask about selection' })
--     vim.keymap.set('n', '<leader>o+', function()
--       require('opencode').append_prompt '@buffer'
--     end, { desc = 'Add buffer to prompt' })
--     vim.keymap.set('v', '<leader>o+', function()
--       require('opencode').append_prompt '@selection'
--     end, { desc = 'Add selection to prompt' })
--     vim.keymap.set('n', '<leader>on', function()
--       require('opencode').command 'session_new'
--     end, { desc = 'New session' })
--     vim.keymap.set('n', '<leader>oy', function()
--       require('opencode').command 'messages_copy'
--     end, { desc = 'Copy last response' })
--     vim.keymap.set('n', '<S-C-u>', function()
--       require('opencode').command 'messages_half_page_up'
--     end, { desc = 'Messages half page up' })
--     vim.keymap.set('n', '<S-C-d>', function()
--       require('opencode').command 'messages_half_page_down'
--     end, { desc = 'Messages half page down' })
--     vim.keymap.set({ 'n', 'v' }, '<leader>os', function()
--       require('opencode').select()
--     end, { desc = 'Select prompt' })
--     vim.keymap.set('n', '<leader>of', function()
--       require('opencode').focus()
--     end, { desc = 'Focus' })
--
--     -- Example: keymap for custom prompt
--     vim.keymap.set('n', '<leader>oe', function()
--       require('opencode').prompt 'Explain @cursor and its context'
--     end, { desc = 'Explain this code' })
--   end,
-- }
