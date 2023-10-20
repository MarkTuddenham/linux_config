local opt = vim.opt

opt.wildmenu = true
opt.wildmode = { "longest", "full" }
opt.wildignore = { "*.o", "*~", "*.pyc", "*pycache*" }
opt.wildoptions = "pum"
opt.autoread = true

opt.spelllang = "en_gb"
opt.spell = false
-- opt.fileformat = 'unix'

-- Cool floating window popup menu for completion on command line
opt.pumblend = 17
-- opt.complete = ""

opt.showmode = false
opt.showcmd = true
opt.cmdheight = 2 -- Height of the command bar, higher helps prevent "press enter" messages
opt.incsearch = true -- Makes search act like search in modern browsers
opt.showmatch = true -- show matching brackets when text indicator is over them
opt.relativenumber = true -- Show line numbers
opt.number = true -- But show the actual number for the line we're on
opt.ignorecase = true -- Ignore case when searching...
opt.smartcase = true -- ... unless there is a capital letter in the query
opt.hidden = false -- I don't like having buffers stay around
opt.cursorline = false -- Highlight the current line
opt.equalalways = false -- I don't like my windows changing all the time
opt.splitright = true -- Prefer windows splitting to the right
opt.splitbelow = true -- Prefer windows splitting to the bottom
opt.updatetime = 500 -- Make updates happen faster
opt.hlsearch = true
opt.scrolloff = 10 -- Make it so there are always ten lines below my cursor

-- Tabs
opt.smarttab = true
opt.autoindent = true
opt.cindent = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = false

-- vim.g.python_recommended_style = 0 -- python overwrites tab settings because python defines a tab as 8 spaces lol

opt.wrap = false
opt.breakindent = true
opt.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly
opt.linebreak = true

opt.list = true
opt.listchars = "tab:>\\ ,trail:¬"

-- But turn wrap and spell on for latex and plain text files
vim.cmd('au BufEnter * if &ft == "tex" | set wrap | set spell | set conceallevel=2 | endif')
vim.cmd('au BufEnter * if &ft == "plaintex" | set wrap | set spell | set conceallevel=2 | endif')
vim.cmd('au BufEnter * if &ft == "plaintext" | set wrap | set spell | set conceallevel=2 | endif')
vim.cmd('au BufEnter * if &ft == "gitcommit" | set wrap | set spell | set conceallevel=2 | endif')
vim.cmd('au BufEnter * if &ft == "markdown" | set wrap | set spell | set conceallevel=2 | set expandtab | endif')

opt.foldmethod = "marker"
opt.foldlevel = 0
opt.modelines = 1

opt.belloff = "all" -- Just turn the dang bell off

opt.clipboard = "unnamedplus"

opt.inccommand = "split"
opt.swapfile = true
opt.undofile = true
-- opt.undodir = "$/.cache/nvim/undo"
opt.shada = { "!", "'1000", "<50", "s10", "h" }

opt.termguicolors = true

-- opt.mouse = "n" -- Turn mouse on in normal mode

-- Helpful related items:
--	 1. :center, :left, :right
--	 2. gw{motion} - Put cursor back after formatting motion.
--
-- TODO: w, {v, b, l}
opt.formatoptions = opt.formatoptions
	- "a" -- Auto formatting is BAD.
	- "t" -- Don't auto format my code. I got linters for that.
	+ "c" -- In general, I like it when comments respect textwidth
	+ "q" -- Allow formatting comments w/ gq
	- "o" -- O and o, don't continue comments
	+ "r" -- But do continue when pressing enter.
	+ "n" -- Indent past the formatlistpat, not underneath it.
	+ "j" -- Auto-remove comments if possible.
	- "2" -- I'm not in gradeschool anymore

-- set joinspaces
opt.joinspaces = false -- Two spaces and grade school, we're done

-- set fillchars=eob:~
opt.fillchars = { eob = "~" }

vim.g.HardMode_level = "wannabe"
vim.g.HardMode_hardmodeMsg = "Don't use this!"
vim.cmd("au VimEnter,BufNewFile,BufReadPost * silent! call HardMode()")

vim.g.camelcasemotion_key = "," -- '<leader>'

-- vim.g.vim_markdown_math = 1

-- autocmd BufWritePre *.c lua vim.lsp.buf.formatting_sync(nil, 1000)
-- autocmd BufWritePre *.cpp lua vim.lsp.buf.formatting_sync(nil, 1000)

vim.cmd("source $HOME/.config/nvim/keybindings.vim")

-- tex
-- conceallevel set in autocommands above
-- opt.conceallevel = 2
vim.g.tex_flavor = "latex"
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_quickfix_mode = 0
vim.g.vimtex_syntax_conceal = {
	math_super_sub = 0,
}
-- vim.g.vimtex_syntax_conceal_default = 0 -- if using tex-conceal instead
-- vim.g.tex_conceal = 'abdmg'
-- vim.g.tex_superscripts= "[0-9a-zA-W.,:;+-<>/()=]"
-- vim.g.tex_subscripts= "[0-9aehijkmnoprstuvx,+-/().]"

vim.g.venom_root_markers = {'.venv', '.venv/', 'venv', 'venv/'}
vim.g.venom_auto_activate = 0
-- vim.g.venom_echo = 0
-- vim.g.venom_quite = 1

vim.cmd([[
	au TextYankPost * silent! lua vim.highlight.on_yank()
]])
