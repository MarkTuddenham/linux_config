
local opt = vim.opt

opt.wildmenu = true
opt.wildmode = { "longest", "full" }
opt.wildignore = "__pycache__"
opt.wildignore = opt.wildignore + { "*.o", "*~", "*.pyc", "*pycache*" }
opt.autoread = true

opt.spelllang = 'en_gb'
opt.spell = false

-- opt.fileformat = 'unix'

-- Cool floating window popup menu for completion on command line
opt.pumblend = 17

opt.showmode = false
opt.showcmd = true
opt.cmdheight = 1 -- Height of the command bar
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
opt.hlsearch = false -- I wouldn't use this without my DoNoHL function
opt.scrolloff = 10 -- Make it so there are always ten lines below my cursor

-- Tabs
opt.smarttab = true
opt.autoindent = true
opt.cindent = true
opt.wrap = false

-- But turn wrap and spell on for latex and plain text files
vim.cmd('au BufEnter * if &ft == "tex" | set wrap | set spell | endif')
vim.cmd('au BufEnter * if &ft == "plaintex" | set wrap | set spell | endif')
vim.cmd('au BufEnter * if &ft == "plaintext" | set wrap | set spell | endif')
vim.cmd('au BufEnter * if &ft == "gitcommit" | set wrap | set spell | endif')

opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true

opt.breakindent = true
opt.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly
opt.linebreak = true

opt.foldmethod = "marker"
opt.foldlevel = 0
opt.modelines = 1

opt.belloff = "all" -- Just turn the dang bell off

opt.clipboard = "unnamedplus"

opt.inccommand = "split"
opt.swapfile = false -- Living on the edge
opt.shada = { "!", "'1000", "<50", "s10", "h" }

-- opt.mouse = "n" -- Turn mouse on in normal mode

-- Helpful related items:
--   1. :center, :left, :right
--   2. gw{motion} - Put cursor back after formatting motion.
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

vim.g.HardMode_level = 'wannabe'
vim.cmd('au VimEnter,BufNewFile,BufReadPost * silent! call HardMode()')
