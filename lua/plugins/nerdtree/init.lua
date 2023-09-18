-- add a file tree and file functions
return {
	'preservim/nerdtree',
	config = function()
		vim.keymap.set('n', '<leader>f', ':NERDTreeFind<CR>')
	end,
}
