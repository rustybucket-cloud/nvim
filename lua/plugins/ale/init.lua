return {
	'dense-analysis/ale',
	config = function()
		vim.cmd [[
		  let g:ale_linters = {
		  \  'javascript': ['eslint'],
		  \}
		  let g:ale_fix_on_save = 1
		]]
	end
}
