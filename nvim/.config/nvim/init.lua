if require('tudders.first_load')() then
  return
end

require('tudders.plugins')

-- Leader key -> ","
--
-- In general, it's a good idea to set this early in your config, because otherwise
-- if you have any mappings you set BEFORE doing this, they will be set to the OLD
-- leader.
vim.g.mapleader = ","

require('tudders.config')
-- require('tudders.statusline')


vim.g.vim_markdown_math = 1

-- autocmd BufWritePre *.c lua vim.lsp.buf.formatting_sync(nil, 1000)
-- autocmd BufWritePre *.cpp lua vim.lsp.buf.formatting_sync(nil, 1000)

vim.g.cpp_class_scope_highlight = 1
vim.g.cpp_class_scope_highlight = 1
vim.g.cpp_class_decl_highlight = 1
vim.g.cpp_member_variable_highlight = 1
vim.g.cpp_experimental_simple_template_highlight = 1

vim.g.HardMode_level = 'wannabe'
vim.g.HardMode_hardmodeMsg = 'Don\'t use this!'

vim.cmd('source $HOME/.config/nvim/keybindings.vim')
