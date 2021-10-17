local ls = require("luasnip")

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node

local u = require('tudders.snippets.utils')

local tex_maths = function()
	return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end

-- local tex_comment = function()
-- 	return vim.eval('vimtex#syntax#in_comment()') == 1
-- end

-- local is_in_tex_env = function(name)
-- 	return function()
-- 		local x, y = vim.eval("vimtex#env#is_inside('" + name + "')")
-- 		return x ~= '0' and y ~= '0'
-- 	end
-- end

local recurse_item
recurse_item = function()
	return sn(nil, {
		c(1, {
			-- important!! Having the sn(...) as the first choice will cause infinite recursion.
			t({""}),
			-- The same dynamicNode as in the snippet (also note: self reference).
			sn(nil, {t({"", "\t\\item "}), i(1), d(2, recurse_item, {})}),
		}),
	});
end

--stylua: ignore
local snippets = u.make {

	beg = {
		desc = "Environments -> \\begin{...}",
		t{"\\begin{"}, i(1, "env"), t{"}", ""}, i(0), t{"", "\\end{"}, u.same(1), t{"}"},
	},

	-- TODO: can we add the rows and cols dynamically from the "l|cc" part?
	table = {
		desc = "Table environment",
		t{"\\begin{table}["}, i(1, "!htpb"), t{"]", "\t\\centering", "\t\\begin{tabular}{"}, i(2, "l|cc"),
		t{"}", "\t", "\t\\end{tabular}", "\t\\caption{"}, i(3, "caption"), t{"}\\label{tab:"}, i(4, "label"), t{"}", "\\end{table}"}
	},

	fig = {
		desc = "Figure environment",
		t{"\\begin{figure}["}, i(1, "!htpb"), t{"]", "\t\\centering", "\t\\includegraphics[width=0.7\\textwidth]{"}, i(2, "image.jpg"),
		t{"}", "\t\\caption{"}, i(3, "caption"), t{"}\\label{fig:"}, i(4, "label"), t{"}", "\\end{figure}"}
	},

	enum = {
		desc = "Enumerate environment",
		t{"\\begin{enumerate}", "\t\\item "}, i(1, "item"), d(2, recurse_item, {}), t{"", "\\end{enumerate}", ""}
	},

	item = {
		desc = "Itemize environment",
		t({"\\begin{itemize}", "\t\\item "}), i(1, "item"), d(2, recurse_item, {}), t({"", "\\end{itemize}", ""})
	},

	algin = {
		desc = "align environment",
		t({"\\begin{align}", "\t"}), i(1, "maths"), t({"", "\\end{align}", ""})
	},


	pac = {
		desc = "Use package",
		"\\usepackage[", i(1), "]{", i(0), "}"
	}


}

--stylua: ignore
local autosnippets = {

  s({trig= "...", desc="dots", wordTrig=false} , t{"\\dots "}),

	s({trig="pmat", desc = "pmatrix", wordTrig=false},
		{t{"\\begin{pmatrix}", ""}, i(0), t{"", "\\end{pmatrix}"}}
	),

	s({trig="bmat", desc = "bmatrix", wordTrig=false},
		{t{"\\begin{bmatrix}", ""}, i(0), t{"", "\\end{bmatrix}"}}
	),

	-- non Maths mode specific
  s({trig= "-", desc="em-dash", wordTrig=true} , t{"---"}, {condition=u.neg(tex_maths)}),
  s(
		{trig= "dm", desc="Display Maths env"},
		{t{"\\[",""}, i(0, "maths"), t{"","\\]"}},
		{condition=u.neg(tex_maths)}
	),

  -- s({trig= "$", desc="Inline maths", wordTrig=false}, {t{"$"}, i(1, "inline maths"), t{"$"}, i(0)}, {condition=tex_maths}),

	-- Maths mode specific
  s({trig= "implies", desc="\\implies", wordTrig=false} , t{"\\implies "}, {condition=tex_maths}),
  s({trig= "implied by", desc="\\impliedby", wordTrig=false} , t{"\\impliedby "}, {condition=tex_maths}),
  s({trig= "iff", desc="\\iff", wordTrig=false} , t{"\\iff "}, {condition=tex_maths}),
  s({trig= "!=", desc="not equals", wordTrig=false} , t{"\\neq "}, {condition=tex_maths}),
  s({trig= "<=", desc="less than or equals", wordTrig=false} , t{"\\leq "}, {condition=tex_maths}),
  s({trig= ">=", desc="greater than or equals", wordTrig=false} , t{"\\geq "}, {condition=tex_maths}),
  s({trig= "in", desc="in", wordTrig=false} , t{"\\in "}, {condition=tex_maths}),
  s({trig= "oo", desc="infinity", wordTrig=false} , t{"\\infty "}, {condition=tex_maths}),
  s({trig= "EE", desc="there exists", wordTrig=false} , t{"\\exists "}, {condition=tex_maths}),
  s({trig= "AA", desc="for all", wordTrig=false} , t{"\\forall "}, {condition=tex_maths}),
  s({trig= "sub", desc="subset", wordTrig=false} , t{"\\subseteq "}, {condition=tex_maths}),
  s({trig= "ssub", desc="strict subset", wordTrig=false} , t{"\\subset "}, {condition=tex_maths}),
  s({trig= "ceil", desc="ceil", wordTrig=false} , {t{"\\left\\lceil "}, i(1), t{" \\right\\rceil"}}, {condition=tex_maths}),
  s({trig= "floor", desc="floor", wordTrig=false} , {t{"\\left\\lfloor "}, i(1), t{" \\right\\rfloor"}}, {condition=tex_maths}),
  s({trig= "sq", desc="square root", wordTrig=false} , {t{"\\sqrt{"}, i(1), t{"}"}}, {condition=tex_maths}),
  s({trig= "exp", desc="exponential", wordTrig=false} , {t{"\\exp{"}, i(1), t{"}"}}, {condition=tex_maths}),
  s({trig= "sr", desc="squared", wordTrig=false} , t{"^2"}, {condition=tex_maths}),
  s({trig= "cb", desc="cubed", wordTrig=false} , t{"^3"}, {condition=tex_maths}),

	-- TODO: auto subscrit x1 -> x_1, x11 -> x_{11}
	-- TODO: the above but with i,j,k subscripts
	-- TODO: the above but with i+1 e.g. xp1 -> x_{n+1}

	-- TODO: one with trig "/" that takes the prev word and puts in num
  s(
		{trig= "frac", desc="Maths fraction"},
		{t{"\\frac{"}, i(1, "num"), t{"}{"}, i(0, "denom"), t{"}"}},
		{condition=tex_maths}
	),

  s(
		{trig= "lr(", desc="left right braces"},
		{t{"\\left("}, i(1, "maths"),  t{"\\right)"}},
		{condition=tex_maths}
	),
  s(
		{trig= "lr[", desc="left right sq braces"},
		{t{"\\left["}, i(1, "maths"),  t{"\\right]"}},
		{condition=tex_maths}
	),
  s(
		{trig= "lr{", desc="left right brackets"},
		{t{"\\left\\{"}, i(1, "maths"),  t{"\\right\\}"}},
		{condition=tex_maths}
	),
  s(
		{trig= "lr|", desc="left right bars"},
		{t{"\\left|"}, i(1, "maths"),  t{"\\right|"}},
		{condition=tex_maths}
	),
  s(
		{trig= "lr<", desc="left right angle brackets"},
		{t{"\\left\rangle "}, i(1, "maths"),  t{" \\right\rangle"}},
		{condition=tex_maths}
	),

  s(
		{trig= "sum", desc="sum"},
		{
			t{"\\sum_{"},
			c(1, {t{"i=1"}, i(1)}),
			t{"}^{"},
			c(2, {t{"\\infty"}, i(1)}),
			t{"}"}
		},
		{condition=tex_maths}
	),

  s(
		{trig= "taylor", desc="Taylor series"},
		{
			t{"\\sum_{"}, i(1), t{"=1"},
			t{"}^{\\infty} c_"}, u.same(1), t{" \\left( x-a \\right)^"}, u.same(1)
		},
		{condition=tex_maths}
	),


}



return {
	snippets = snippets,
	autosnippets = autosnippets
}
