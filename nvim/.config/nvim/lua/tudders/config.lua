require('tudders.opts')
require('tudders.telescope')
require('tudders.lsp')
require('tudders.dap')

-- require('which-key').setup()

require('lualine').setup{
	options = {
		theme = 'horizon',
	},
	sections = {
		lualine_a = {'mode', 'paste'},
		lualine_b = {'branch', 'diff'},
		lualine_c = {
			{'filename', file_status = true, full_path = true},
			{
				'diagnostics',
				sources = {'nvim_lsp'},
				symbols = {error = 'E', warn = 'W', info = 'I', hint = 'H'}
			}
		},
		lualine_x = {'filetype'},
		lualine_y = {'progress'},
		lualine_z = {{'location', icon = ''}}
	},
	extensions = {'fugitive'}
}

require('github-theme').setup{
	transparent = true,
	theme_style = 'dimmed',
	sidebars = {"qf", "vista_kind", "terminal", "packer"},
	colors = {
		border_highlight = 'bg',
		-- fg = 'white',
		syntax = {
			comment = '#BB00BB',
		}
	},
	-- comment_style = "italic",
	-- keyword_style = "NONE",
	-- function_style = "NONE",
	-- variable_style = "NONE"
}
-- override theme colours
vim.cmd([[
function! MyHighlights() abort
	highlight! link Conceal Comment
endfunction

augroup MyColors
		autocmd!
		autocmd ColorScheme * call MyHighlights()
augroup END
]])

require("git-worktree").setup()
require("refactoring").setup()

require('harpoon').setup{
	global_settings = {
			save_on_toggle = false,
			save_on_change = true,
	}
}

local harpoon_opts = {noremap = true, silent = true}
vim.api.nvim_set_keymap('n', '<leader>tt', '<cmd>lua require("harpoon.mark").add_file()<cr>', harpoon_opts)
vim.api.nvim_set_keymap('n', '<leader>tl', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', harpoon_opts)
vim.api.nvim_set_keymap('n', '<leader>1', '<cmd>lua require("harpoon.ui").nav_file(1)<cr>', harpoon_opts)
vim.api.nvim_set_keymap('n', '<leader>2', '<cmd>lua require("harpoon.ui").nav_file(2)<cr>', harpoon_opts)
vim.api.nvim_set_keymap('n', '<leader>3', '<cmd>lua require("harpoon.ui").nav_file(3)<cr>', harpoon_opts)
vim.api.nvim_set_keymap('n', '<leader>4', '<cmd>lua require("harpoon.ui").nav_file(4)<cr>', harpoon_opts)
vim.api.nvim_set_keymap('n', '<leader>5', '<cmd>lua require("harpoon.ui").nav_file(5)<cr>', harpoon_opts)


require('nvim-treesitter.configs').setup{
	ensure_installed = 'maintained', -- one of 'all', 'maintained' (parsers with maintainers), or a list of languages
	ignore_install = { 'javascript' }, -- List of parsers to ignore installing
	highlight = {
		enable = true,							-- false will disable the whole extension
		disable = { 'rust', 'latex', 'tex', 'vim'},  -- list of language that will be disabled
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = true,
	},
	query_linter = {
		enable = true,
		use_virtual_text = true,
		lint_events = {"BufWrite", "CursorHold"},
	}
}


require('gitsigns').setup{
	signs = {
		add					 = {hl = 'GitSignsAdd'	 , text = '│', numhl='GitSignsAddNr'	 , linehl='GitSignsAddLn'},
		change			 = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
		delete			 = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
		topdelete		 = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
		changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
	},
	numhl = false,
	linehl = false,
	word_diff = false,
	keymaps = {
		-- Default keymap options
		noremap = true,
		buffer = true,

		['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require(\"gitsigns.actions\").next_hunk()<cr>'"},
		['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require(\"gitsigns.actions\").prev_hunk()<cr>'"},

		['n <leader>hs'] = '<cmd>lua require("gitsigns").stage_hunk()<cr>',
		['v <leader>hs'] = '<cmd>lua require("gitsigns").stage_hunk({vim.fn.line("."), vim.fn.line("v")})<cr>',
		['n <leader>hu'] = '<cmd>lua require("gitsigns").undo_stage_hunk()<cr>',
		['n <leader>hr'] = '<cmd>lua require("gitsigns").reset_hunk()<cr>',
		['v <leader>hr'] = '<cmd>lua require("gitsigns").reset_hunk({vim.fn.line("."), vim.fn.line("v")})<cr>',
		['n <leader>hR'] = '<cmd>lua require("gitsigns").reset_buffer()<cr>',
		['n <leader>hp'] = '<cmd>lua require("gitsigns").preview_hunk()<cr>',
		['n <leader>hb'] = '<cmd>lua require("gitsigns").blame_line(true)<cr>',
		['n <leader>hw'] = '<cmd>lua require("gitsigns").toggle_word_diff()<cr>',

		-- Text objects
		['o ih'] = ':<C-U>lua require("gitsigns.actions").select_hunk()<cr>',
		['x ih'] = ':<C-U>lua require("gitsigns.actions").select_hunk()<cr>'
	},
	attach_to_untracked = true,
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	max_file_length = 40000,
	use_decoration_api = true,
	use_internal_diff = true,  -- If luajit is present
	watch_gitdir = {
		interval = 1000,
		follow_files = true
	},
	current_line_blame = true,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
		delay = 750,
	},
	current_line_blame_formatter_opts = {
		relative_time = true
	},
	yadm = {
		enable = false
	}
}

vim.api.nvim_set_keymap('n', '<F5>', '<cmd>:UndotreeToggle<cr>', {})
