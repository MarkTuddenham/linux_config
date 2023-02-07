

-- inoremap <C-f> <Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>
-- nnoremap <C-f> : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>

local M = {}

M.create_fig = function()
	local name = vim.api.nvim_get_current_line()
	-- todo: find root dir for figures
	local cmd = "inkscape-figures create "..name.." ./figures/"
	os.execute(cmd)
	-- local handle = io.popen(cmd)
	-- local result = handle:read("*a")
	-- handle:close()

	local lineNum = vim.api.nvim_win_get_cursor(0)[1]
	local text = {
		"\\begin{figure}[ht]",
			"\t\\centering",
			"\t\\incfig{figures/"..name.."}",
			"\t\\caption{"..name.."}",
			"\t\\label{fig:"..name.."}",
	"\\end{figure}",
	}
	vim.api.nvim_buf_set_lines(0, lineNum-1, lineNum, true, text)
end


M.edit_fig = function()
	-- todo: find root dir for figures
	local handle = io.popen("inkscape-figures edit ./figures/ &")
	-- local result = handle:read("*a")
	handle:close()
	-- print(result)
end

return M
