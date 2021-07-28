require('tudders.opts')
require('tudders.telescope')
require('tudders.statusline')

require('which-key').setup()

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
	extensions = {'fugitive'},
}

require('github-theme').setup{
  transparent = true,
  themeStyle = 'dimmed',
  colors = {
    border_highlight = 'bg',
  }
}

require('harpoon').setup({
    global_settings = {
        save_on_toggle = false,
        save_on_change = true,
    },
})
local harpoon_opts = {noremap = true, silent = true}
vim.api.nvim_set_keymap('n', '<leader>tt', '<cmd>lua require("harpoon.mark").add_file()<cr>', harpoon_opts)
vim.api.nvim_set_keymap('n', '<leader>tl', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', harpoon_opts)
vim.api.nvim_set_keymap('n', '<leader>1', '<cmd>lua require("harpoon.ui").nav_file(1)<cr>', harpoon_opts)
vim.api.nvim_set_keymap('n', '<leader>2', '<cmd>lua require("harpoon.ui").nav_file(2)<cr>', harpoon_opts)
vim.api.nvim_set_keymap('n', '<leader>3', '<cmd>lua require("harpoon.ui").nav_file(3)<cr>', harpoon_opts)
vim.api.nvim_set_keymap('n', '<leader>4', '<cmd>lua require("harpoon.ui").nav_file(4)<cr>', harpoon_opts)
vim.api.nvim_set_keymap('n', '<leader>5', '<cmd>lua require("harpoon.ui").nav_file(5)<cr>', harpoon_opts)

require('nvim-treesitter.configs').setup {
  ensure_installed = 'maintained', -- one of 'all', 'maintained' (parsers with maintainers), or a list of languages
  ignore_install = { 'javascript' }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { 'c', 'rust' },  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = {"BufWrite", "CursorHold"},
  },
}

require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  numhl = false,
  linehl = false,
  keymaps = {
    -- Default keymap options
    noremap = true,
    buffer = true,

    ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<cr>'"},
    ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<cr>'"},

    ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<cr>',
    ['v <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<cr>',
    ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<cr>',
    ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<cr>',
    ['v <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<cr>',
    ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<cr>',
    ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<cr>',
    ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line(true)<cr>',

    -- Text objects
    ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<cr>',
    ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<cr>'
  },
  watch_index = {
    interval = 1000,
    follow_files = true
  },
  current_line_blame = true,
  current_line_blame_delay = 750,
  current_line_blame_position = 'eol',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  word_diff = false,
  use_decoration_api = true,
  use_internal_diff = true,  -- If luajit is present
}

-- Compe setup
require('compe').setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    nvim_lsp = true;
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-n>'
  elseif check_back_space() then
    return t '<Tab>'
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-p>'
  else
    return t '<S-Tab>'
  end
end

vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', {expr = true})
vim.api.nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', {expr = true})
vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})
vim.api.nvim_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})

