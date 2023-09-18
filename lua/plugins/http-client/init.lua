-- http client in vim
return {
	'aquach/vim-http-client',
	config = function()
		vim.keymap.set('n', '<leader>hr', ':HTTPClientDoRequest<cr>', { desc = '[h]ttp [r]equest' })
	end
}
