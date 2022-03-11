local opts = { noremap = true, silent = true }

require("telescope").setup({
	defaults = {
		color_devicons = true,
		layout_config = {
			prompt_position = "top",
			horizontal = {
				preview_width = function(_, cols, _)
					if cols > 200 then
						return math.floor(cols * 0.4)
					else
						return math.floor(cols * 0.6)
					end
				end,
			},
		},
		sorting_strategy = "ascending",
		file_ignore_patterns = {
			".git/.*", -- we have set hidden files to shown, but we don't want git dotfiles
			".*venv/.*",
		},
	},
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = false, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- 'smart_case' or 'ignore_case' or 'respect_case'
		},
	},
})
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("fzf")

require('telescope').load_extension('gh')
vim.api.nvim_set_keymap("n", "<leader>gi", "<cmd>Telescope gh issues<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>gp", "<cmd>Telescope gh pull_request<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>gr", "<cmd>Telescope gh run<cr>", opts)

vim.api.nvim_set_keymap("n", "<leader>ff", '<cmd>lua require("telescope.builtin").find_files({hidden=true})<cr>', opts)
vim.api.nvim_set_keymap(
	"n",
	"<leader>fo",
	'<cmd>lua require("telescope.builtin").file_browser({hidden=true})<cr>',
	opts
)
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)

require("telescope").load_extension("dap")
vim.api.nvim_set_keymap("n", "<leader>fdc", "<cmd>Telescope commands<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>fdv", "<cmd>Telescope variables<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>fdf", "<cmd>Telescope frames<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>fdb", "<cmd>Telescope list_breakpoints<cr>", opts)

require("telescope").load_extension("git_worktree")
vim.api.nvim_set_keymap(
	"n",
	"<leader>gw",
	'<cmd>lua require("telescope").extensions.git_worktree.git_worktrees()<cr>',
	opts
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>gc",
	'<cmd>lua require("telescope").extensions.git_worktree.create_git_worktree()<cr>',
	opts
)

vim.api.nvim_set_keymap("n", "<leader>rr", '<cmd>lua require("tudders.telescope").refactors()<cr>', opts)
vim.api.nvim_set_keymap("v", "<leader>rr", '<cmd>lua require("tudders.telescope").refactors()<cr>', opts)

M = {}

-- telescope refactoring helper
local function refactor(prompt_bufnr)
	local content = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
	require("telescope.actions").close(prompt_bufnr)
	require("refactoring").refactor(content.value)
end

M.refactors = function()
	require("telescope.pickers").new({}, {
		prompt_title = "refactoring",
		finder = require("telescope.finders").new_table({
			results = require("refactoring").get_refactors(),
		}),
		sorter = require("telescope.config").values.generic_sorter({}),
		attach_mappings = function(_, map)
			map("i", "<CR>", refactor)
			map("n", "<CR>", refactor)
			return true
		end,
	}):find()
end

return M
