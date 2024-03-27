
require("tudders.opts")
require("tudders.telescope")
require("tudders.git-worktree")
require("tudders.dap")
local lsp = require("tudders.lsp")

-- require('which-key').setup()

-- vim.api.nvim_set_keymap("n", "<leader>ic", "<cmd>lua require('tudders.latex_scape').create_fig()<cr>", {silent=true})
-- vim.api.nvim_set_keymap("n", "<leader>ie", "<cmd>lua require('tudders.latex_scape').edit_fig()<cr>", {silent=true})
vim.api.nvim_set_keymap("n", "<leader>cn", "<cmd>cnext<cr>", {silent=true})
vim.api.nvim_set_keymap("n", "<leader>cp", "<cmd>cprev<cr>", {silent=true})


-- par formatting for paragraphs
vim.api.nvim_set_keymap("n", "<leader>fp", "<cmd>% !par -w79<cr>", {silent=true})
vim.api.nvim_set_keymap("v", "<leader>fp", ":'<,'> !par -w79<cr>", {silent=true})
vim.api.nvim_set_keymap("n", "<leader>fjp", "<cmd>% !par -jw79<cr>", {silent=true})
vim.api.nvim_set_keymap("v", "<leader>fjp", ":'<,'> !par -jw79<cr>", {silent=true})

-- Vista!! toggles
vim.api.nvim_set_keymap("n", "<leader>v", "<cmd>Vista!!<cr>", {silent=true})
vim.g.vista_default_executive = "nvim_lsp"

require("Comment").setup()
require('crates').setup()

require("gruvbox").setup({
  terminal_colors = true, -- add neovim terminal colors
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    emphasis = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "soft", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = true,
})
vim.cmd("colorscheme gruvbox")

require("lsp_lines").setup()
vim.diagnostic.config({
  -- virtual_text = false,
   virtual_lines = { only_current_line = true }
})

require('licenses').setup({
    copyright_holder = 'Mark Tuddenham',
    email = 'mark@tudders.com',
    license = 'MIT',
})

require('rust-tools').setup({
	autoSetHints = true,
	tools = {
		inlay_hints = {
			highlight = "Normal",
		},
	},
	
	server = {
		on_attach = lsp.on_attach,
		settings = {
			["rust-analyzer"] = {
				cargo = {features = "all"},
				check = {
            command = "clippy"
        }
			}
		}
	}
})

require("lualine").setup({
	options = {
    theme = 'gruvbox',
		icons_enabled = false,
		section_separators = '',
		component_separators = '',
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
	sections = {
		lualine_a = { "hostname", "mode", "paste" },
		lualine_b = {
			{ "filename",
			file_status = true,
			new_file_status = true,
			path = 2,
		},
			{
				"diagnostics",
				sources = { 'nvim_lsp',"nvim_diagnostic", 'nvim_workspace_diagnostic' },
				symbols = { error = "E", warn = "W", info = "I", hint = "H" },
			},
		},
		lualine_c = { "branch", "diff" },
		lualine_x = { "searchcount", "selectioncount",  },
		lualine_y = { "filetype", 'encoding', 'fileformat' },
		lualine_z = { "progress", "location" },
	},
	extensions = { "fugitive", "fzf", "nvim-dap-ui" },
})

require("refactoring").setup()

require("harpoon").setup({
	global_settings = {
		save_on_toggle = false,
		save_on_change = true,
	},
})

local harpoon_opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>tt", '<cmd>lua require("harpoon.mark").add_file()<cr>', harpoon_opts)
vim.api.nvim_set_keymap("n", "<leader>tl", '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', harpoon_opts)
vim.api.nvim_set_keymap("n", "<leader>1", '<cmd>lua require("harpoon.ui").nav_file(1)<cr>', harpoon_opts)
vim.api.nvim_set_keymap("n", "<leader>2", '<cmd>lua require("harpoon.ui").nav_file(2)<cr>', harpoon_opts)
vim.api.nvim_set_keymap("n", "<leader>3", '<cmd>lua require("harpoon.ui").nav_file(3)<cr>', harpoon_opts)
vim.api.nvim_set_keymap("n", "<leader>4", '<cmd>lua require("harpoon.ui").nav_file(4)<cr>', harpoon_opts)
vim.api.nvim_set_keymap("n", "<leader>5", '<cmd>lua require("harpoon.ui").nav_file(5)<cr>', harpoon_opts)

require("nvim-treesitter.configs").setup({
	ensure_installed = "all", -- one of 'all', 'maintained' (parsers with maintainers), or a list of languages
	ignore_install = { "javascript" }, -- List of parsers to ignore installing
	highlight = {
		enable = true, -- false will disable the whole extension
		-- disable = {"latex", "tex", "vim" }, -- list of language that will be disabled
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = true,
	},
	query_linter = {
		enable = true,
		use_virtual_text = true,
		lint_events = { "BufWrite", "CursorHold" },
	},
})

require("gitsigns").setup({
	signs = {
		add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
		change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
		delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		changedelete = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
	},
	numhl = false,
	linehl = false,
	word_diff = false,
	on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map('n', '<leader>hs', gs.stage_hunk)
    map('n', '<leader>hr', gs.reset_hunk)
    map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end,
	attach_to_untracked = true,
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	max_file_length = 40000,
	diff_opts = {
		internal = true,
	},
	watch_gitdir = {
		interval = 1000,
		follow_files = true,
	},
	current_line_blame = true,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 750,
	},
	current_line_blame_formatter_opts = {
		relative_time = true,
	},
	yadm = {
		enable = false,
	},
})

vim.api.nvim_set_keymap("n", "<F5>", "<cmd>:UndotreeToggle<cr>", {})
