return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  event = "VeryLazy",
  config = function(_, opts)
    require("claudecode").setup(opts)

    -- The snacks terminal provider logs an ERROR for any nonzero exit status,
    -- but Neovim reports -1 when the pty job is killed by a signal (closing the
    -- terminal window, quitting nvim) rather than Claude actually failing.
    local logger = require("claudecode.logger")
    local base_error = logger.error
    logger.error = function(...)
      for i = 1, select("#", ...) do
        local part = select(i, ...)
        if type(part) == "string" and part:match("exited with code %-1") then
          return
        end
      end
      return base_error(...)
    end

    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*",
      callback = function(args)
        local map_opts = { buffer = args.buf, silent = true }
        vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", map_opts)
        vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", map_opts)
        vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", map_opts)
        vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", map_opts)
      end,
    })
  end,
  cmd = {
    "ClaudeCode",
    "ClaudeCodeFocus",
    "ClaudeCodeSelectModel",
    "ClaudeCodeAdd",
    "ClaudeCodeSend",
    "ClaudeCodeTreeAdd",
    "ClaudeCodeStatus",
    "ClaudeCodeStart",
    "ClaudeCodeStop",
    "ClaudeCodeOpen",
    "ClaudeCodeClose",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
    "ClaudeCodeCloseAllDiffs",
  },
  keys = {
    { "<leader>a", nil, desc = "AI/Claude Code" },
    { "<leader>ac", function() require("util.ai").open() end, desc = "Toggle AI (claude/opencode)" },
    { "<leader>aP", function() require("util.ai").toggle_provider() end, desc = "Switch AI provider" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
    },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
}
