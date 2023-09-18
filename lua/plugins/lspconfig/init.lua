-- NOTE: This is where your plugins related to LSP can be installed.
--  The configuration is done below. Search for lspconfig to find it below.
return {
	-- LSP Configuration & Plugins
	'neovim/nvim-lspconfig',
	config = function()
		local lspconfig = require('lspconfig')

		-- Set up individual language servers
		lspconfig.somelanguage.setup {
			-- Configuration options specific to this language server
			on_attach = function(client)
				-- Custom setup for the language server when it's attached to a buffer
			end,
			capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
		}

		-- Additional language server setups can follow a similar pattern
		-- lspconfig.anotherlanguage.setup { ... }
	end,
	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		{ 'williamboman/mason.nvim', config = true },
		'williamboman/mason-lspconfig.nvim',

		-- Useful status updates for LSP
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

		-- Additional lua configuration, makes nvim stuff amazing!
		'folke/neodev.nvim',
	},
	opts = {
		servers = {
			eslint = {
				settings = {
					-- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
					workingDirectory = { mode = "auto" },
				},
			},
		},
	}
}
