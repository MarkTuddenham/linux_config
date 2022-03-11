local Worktree = require("git-worktree")

Worktree.setup()

local M = {}
function M.execute(path)
	-- Python venv
	-- vim.cmd(":silent !deactivate")
	vim.cmd(":silent VenomActivate")
end

Worktree.on_tree_change(function(_ --[[op]], metadata, _ --[[upstream]])
	-- print("Switched from " .. metadata.prev_path .. " to " .. metadata.path)
	M.execute(metadata.path)
end)

return M
