return {
  "nickjvandyke/opencode.nvim",
  dependencies = { "folke/snacks.nvim" },
  event = "VeryLazy",
  config = function()
    local ai = require("util.ai")

    ---@type opencode.Opts
    vim.g.opencode_opts = {
      server = {
        start = function()
          require("snacks.terminal").open(ai.opencode_cmd, ai.opencode_terminal_opts)
        end,
      },
    }
  end,
}
