-- Fuzzy Finder Algorithm which requires local dependencies to be built.
-- Only load if `make` is available. Make sure you have the system
-- requirements installed.
return {
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		-- NOTE: If you are having trouble with this installation,
		--       refer to the README for telescope-fzf-native for more instructions.
		build = 'make',
		cond = function()
			return vim.fn.executable 'make' == 1
		end,
		config = function()
			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<leader>gl', builtin.live_grep, { desc = '[g]rep [l]ive' })
			vim.keymap.set('n', '<leader>gs', builtin.grep_string, { desc = '[g]rep [s]tring' })
		end,
	},
	-- Fuzzy Finder (files, lsp, etc)
	{ 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
}
