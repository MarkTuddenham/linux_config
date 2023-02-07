-- if vim.g.snippets ~= "luasnip" then
-- 	return
-- end


local ls = require("luasnip")
local types = require("luasnip.util.types")

-- local sn = ls.snippet_node
-- local t = ls.text_node
-- local i = ls.insert_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node

ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "choiceNode", "Comment" } },
			},
			passive = {
				virt_text = { { "" } },
			},
		},
		-- [types.insertNode] = {
		-- 	passive = {
		-- 		hl_group = "Comment",
		-- 	},
		-- },
	},
	-- -- treesitter-hl has 100, use something higher (default is 200).
	-- ext_base_prio = 200,
	-- -- minimal increase in priority.
	-- ext_prio_increase = 1,
	enable_autosnippets = true,
	ft_func = function()
		return vim.split(vim.bo.filetype, ".", true)
	end,
})

local languages = {"tex", "python", "rust", "sh", "lua"}

for _,lang in ipairs(languages) do
	ls.add_snippets(lang, require("tudders.snippets."..lang).snippets)

	local autosnippets = require("tudders.snippets."..lang).autosnippets
	for _,snip in ipairs(autosnippets) do
		snip.snippetType = "autosnippets"
	end
	ls.add_snippets(lang, autosnippets)

end

-- e.g. loads friendly-snippets
-- require("luasnip/loaders/from_vscode").lazy_load()


vim.cmd([[
	imap <silent><expr> <c-k> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<c-k>'
	inoremap <silent> <c-j> <cmd>lua require('luasnip').jump(-1)<CR>
	imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
	snoremap <silent> <c-k> <cmd>lua require('luasnip').jump(1)<CR>
	snoremap <silent> <c-j> <cmd>lua require('luasnip').jump(-1)<CR>
]])
