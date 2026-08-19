-- Local plugin: shared claude/opencode provider toggle used by claude-code.lua and opencode.lua.
return {
  dir = vim.fn.stdpath 'config' .. '/custom-plugins/bridle',
  name = 'bridle',
  lazy = true,
  keys = {
    { "<leader>a=", function() require("bridle").resize(require("bridle").resize_step) end, desc = "Grow AI window" },
    { "<leader>a-", function() require("bridle").resize(-require("bridle").resize_step) end, desc = "Shrink AI window" },
    { "<leader>a3", function() require("bridle").resize_to(0.3) end, desc = "AI window 30%" },
    { "<leader>a5", function() require("bridle").resize_to(require("bridle").default_width) end, desc = "AI window default size" },
    { "<leader>a7", function() require("bridle").resize_to(0.7) end, desc = "AI window 70%" },
  },
}
