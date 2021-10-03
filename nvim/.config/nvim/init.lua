if require('tudders.first_load')() then
  return
end

require('tudders.plugins')

-- Leader key -> " "
--
-- In general, it's a good idea to set this early in your config, because otherwise
-- if you have any mappings you set BEFORE doing this, they will be set to the OLD
-- leader.
vim.api.nvim_set_keymap('n', '<space>', '<nop>', {})  -- do we have to unmap space first?
vim.g.mapleader = ' '

vim.g.snippets = 'luasnip'

require('tudders.config')
