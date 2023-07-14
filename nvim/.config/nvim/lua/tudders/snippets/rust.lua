-- local ls = require("luasnip")
-- local t = ls.text_node
-- local i = ls.insert_node

local u = require("tudders.snippets.utils")

local snippets = u.make({
	derive = "#[derive(Debug, Clone)]",
	derive_serde = "#[derive(Debug, Clone, Serialize, Deserialize)]",
	use_serde = "use serde::{Serialize, Deserialize};",
})

local autosnippets = {}

return {
	snippets = snippets,
	autosnippets = autosnippets,
}
