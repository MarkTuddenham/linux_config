local ls = require("luasnip")

local snippet = ls.s

local f = ls.f -- function node
local i = ls.i -- insert node
local t = ls.t -- text node

local utils = {}

local str = function(text)
	return t({ text })
end
utils.str = str

local str_snip = function(trig, expanded)
	return ls.parser.parse_snippet({ trig = trig }, expanded)
end
utils.str_snip = str_snip

local tbl_snip = function(tbl)
	return snippet({ trig = tbl.trig, dscr = tbl.desc }, { unpack(tbl) })
end
utils.tbl_snip = tbl_snip

local function char_count_same(c1, c2)
	local line = vim.api.nvim_get_current_line()
	local _, ct1 = string.gsub(line, c1, "")
	local _, ct2 = string.gsub(line, c2, "")
	return ct1 == ct2
end
utils.char_count_same = char_count_same

local function neg(fn)
	return function(...)
		return not fn(...)
	end
end
utils.neg = neg

local shortcut = function(val)
	if type(val) == "string" then
		return { t({ val }), i(0) }
	end

	if type(val) == "table" then
		for k, v in ipairs(val) do
			if type(v) == "string" then
				val[k] = t({ v })
			end
		end
	end

	return val
end
-- utils.shortcut = shortcut

local make = function(tbl)
	local result = {}
	for k, v in pairs(tbl) do
		if v.trig then
			table.insert(result, (snippet({ trig = v.trig, desc = v.desc }, shortcut(v))))
		else
			table.insert(result, (snippet({ trig = k, desc = v.desc }, shortcut(v))))
		end
	end

	return result
end
utils.make = make

local same = function(index)
	return f(function(args)
		return args[1]
	end, { index })
end
utils.same = same

return utils
