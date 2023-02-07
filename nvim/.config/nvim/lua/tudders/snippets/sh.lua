local ls = require("luasnip")
local t = ls.text_node

local u = require("tudders.snippets.utils")

local snippets = u.make({
	-- script_dir = "SCRIPT_DIR=$( cd -- \"$( dirname -- \"${BASH_SOURCE[0]}\" )\" &> /dev/null && pwd )",
	script_dir = "SCRIPT_DIR=$(realpath -s $(dirname ${BASH_SOURCE[0]}))",
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

local autosnippets = {}

return {
	snippets = snippets,
	autosnippets = autosnippets,
}
