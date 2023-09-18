-- floating terminal emulator
return {
	'voldikss/vim-floaterm',
	config = function()
		vim.keymap.set('n', '<leader>t]', ':FloatermNext<CR>', { desc = '[t]erminal next' })
		vim.keymap.set('n', '<leader>t[', ':FloatermPrev<CR>', { desc = '[t]erminal previous' })
		vim.keymap.set('n', '<leader>tn', ':FloatermNew<CR>', { desc = '[t]erminal [n]ew' })
		vim.keymap.set('n', '<leader>tt', ':FloatermToggle<CR>', { desc = '[t]erminal [t]oggle' })
		vim.keymap.set('n', '<C-\\>', ':FloatermToggle<CR>')
		vim.keymap.set('t', '<C-\\>', '<C-\\><C-n>:FloatermToggle<CR>')
		vim.keymap.set('n', '<leader>tk1', ':1FloatermKill<CR>', { desc = '[t]erminal [k]ill 1' })
		vim.keymap.set('n', '<leader>tk2', ':2FloatermKill<CR>', { desc = '[t]erminal [k]ill 2' })
		vim.keymap.set('n', '<leader>tk3', ':3FloatermKill<CR>', { desc = '[t]erminal [k]ill 3' })
	end,
}
