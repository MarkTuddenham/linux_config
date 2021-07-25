require('telescope').setup {
  defaults = {
    color_devicons = true,
    layout_config = {
      prompt_position = 'top',
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
    sorting_strategy = 'ascending',
    file_ignore_patterns = {
      '.git/*', -- we have set hidden files to shown, but we don't want git dotfiles
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = 'smart_case',        -- 'smart_case' or 'ignore_case' or 'respect_case'
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
require('telescope').load_extension('git_worktree')

local opts = {noremap = true, silent = true}
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files({hidden=true})<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>fo', '<cmd>Telescope file_browser<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>fwl', '<cmd>lua require("telescope").extensions.git_worktree.git_worktrees()<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>fwc', '<cmd>lua require("telescope").extensions.git_worktree.create_git_worktree()<cr>', opts)

