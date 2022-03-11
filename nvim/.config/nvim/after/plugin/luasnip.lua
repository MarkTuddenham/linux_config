if vim.g.snippets ~= "luasnip" then
	return
end

local ls = require("luasnip")
local types = require("luasnip.util.types")

-- local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
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
		[types.insertNode] = {
			passive = {
				hl_group = "Comment",
			},
		},
	},
	-- treesitter-hl has 100, use something higher (default is 200).
	ext_base_prio = 200,
	-- minimal increase in priority.
	ext_prio_increase = 1,
	enable_autosnippets = true,
})

-- create snippet
-- s(context, nodes, condition, ...)
-- local snippet = ls.s
-- local snippet_from_nodes = ls.sn

-- This a choice snippet. You can move through with <c-e> (in my config)
-- tbl_snip {
--	 trig = "c",
--	 t { "-- this has a choice: " },
--	 c(1, { t {"hello"}, t {"world"}, }),
--	 i(0),
-- }

local utils = require("tudders.snippets.utils")
local make = utils.make
-- local same = utils.same

local snippets = {}
local autosnippets = {}

snippets.tex = require("tudders.snippets.tex").snippets
autosnippets.tex = require("tudders.snippets.tex").autosnippets

snippets.python = require("tudders.snippets.python").snippets
autosnippets.python = require("tudders.snippets.python").autosnippets

snippets.sh = make({
	script_dir = "SCRIPT_DIR=$( cd -- \"$( dirname -- \"${BASH_SOURCE[0]}\" )\" &> /dev/null && pwd )",
	trap = "trap \"trap - SIGINT SIGTERM ERR; pkill -P $$\" SIGINT SIGTERM ERR EXIT;",
	shebang = "#!/usr/bin/env bash",
	requires_root = {
		desc = "Check if user is root, exits with message if not.",
		t({"if [[ $(id -u) -ne 0 ]]; then",
		"\techo \"This script must be run as root\"",
		"\texit 1",
		"fi"})
	},
	respawn = {
		desc = "Respawn this script as a background process.",
		t({"# Re-spawn as a background process, if we haven't already.",
		"if [[ \"$1\" != \"-n\" ]]; then",
		"\t$0 -n &>/dev/null & disown",
		"\texit $?",
		"fi"})
	},
})

snippets.lua = make({
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

ls.snippets = snippets
ls.autosnippets = autosnippets

-- e.g. loads friendly-snippets
require("luasnip/loaders/from_vscode").lazy_load()

vim.cmd([[
	imap <silent><expr> <c-k> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<c-k>'
	inoremap <silent> <c-j> <cmd>lua require('luasnip').jump(-1)<CR>
	imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
	snoremap <silent> <c-k> <cmd>lua require('luasnip').jump(1)<CR>
	snoremap <silent> <c-j> <cmd>lua require('luasnip').jump(-1)<CR>
]])
