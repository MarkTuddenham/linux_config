local ls = require("luasnip")
local t = ls.text_node
local i = ls.insert_node

local u = require("tudders.snippets.utils")

local snippets = u.make({
	ignore = "--stylua: ignore",

	lf = {
		desc = "table function",
		t({ "local " }),
		i(1),
		t({ " = function(" }),
		i(2),
		t({ ")", "	" }),
		i(0),
		t({ "", "end" }),
	},
})

local autosnippets = {}

return {
	snippets = snippets,
	autosnippets = autosnippets,
}
