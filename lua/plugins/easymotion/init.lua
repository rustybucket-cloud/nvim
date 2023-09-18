return {
	'easymotion/vim-easymotion',
	config = function()
		vim.keymap.set('n', '<leader>m', '<Plug>(easymotion-bd-w)', { desc = '[e]asymotion' })
	end,
}
