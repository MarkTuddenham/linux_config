local ls = require("luasnip")

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node

local u = require("tudders.snippets.utils")

local snippets = u.make {

	beg = {
		desc = "Environments -> \\begin{...}",
		t{"\\begin{"}, i(1, "env"), t{"}", ""}, i(0), t{"", "\\end{"}, u.same(1), t{"}"},
	},

}

local autosnippets = {

	s({trig= "...", desc="dots", wordTrig=false} , t{"\\dots "}),

}

return {
	snippets = snippets,
	autosnippets = autosnippets,
}
