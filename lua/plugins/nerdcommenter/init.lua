  -- adds functions for code comments
return {
	'preservim/nerdcommenter',
	config = function()
		  vim.keymap.set('n', '<leader>ct', '<Plug>NERDCommenterToggle', { desc = '[C]omment [T]oggle' })
		  vim.keymap.set('n', '<leader>ca', '<Plug>NERDCommenterComment', { desc = '[C]omment [A]dd' })
	end,
}

