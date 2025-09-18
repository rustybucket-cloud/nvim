return {
	'catppuccin/nvim',
	name = 'catppuccin',
	priority = 1000,
	opts = {
		flavour = 'mocha', -- latte, frappe, macchiato, mocha
		integrations = { cmp = true, treesitter = true, gitsigns = true, telescope = true, which_key = true },
	},
	config = function()
		require('catppuccin').setup()
		-- Uncomment to make it your default:
		vim.cmd.colorscheme 'catppuccin'
	end,
}

-- -- You can easily change to a different colorscheme.
--     -- Change the name of the colorscheme plugin below, and then
--     -- change the command in the config to whatever the name of that colorscheme is.
--     --
--     -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
--     'folke/tokyonight.nvim',
--     priority = 1000, -- Make sure to load this before all the other start plugins.
--     config = function()
--       ---@diagnostic disable-next-line: missing-fields
--       require('tokyonight').setup {
--         styles = {
--           comments = { italic = false }, -- Disable italics in comments
--         },
--       }
--
--       -- Load the colorscheme here.
--       -- Like many other themes, this one has different styles, and you could load
--       -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
--       -- vim.cmd.colorscheme 'tokyonight-night'
--     end,
--   },
