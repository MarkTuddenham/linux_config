local dap = require("dap")
local api = vim.api

require("nvim-dap-virtual-text").setup({
	enabled = true, -- enable this plugin (the default)
	enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
	highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
	highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
	show_stop_reason = true, -- show stop reason when stopped for exceptions
	commented = false, -- prefix virtual text with comment string
	-- experimental features:
	virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
	all_framee = true, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
	virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
	virt_text_win_col = nil,							-- position the virtual text at a fixed window column (starting from the first text column) ,
	-- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
})

require("dapui").setup({
	icons = { expanded = "▾", collapsed = "▸" },
	mappings = {
		-- Use a table to apply multiple mappings
		expand = { "<cr>", "<2-LeftMouse>" },
		open = "o",
		remove = "d",
		edit = "e",
		repl = "r",
	},
	sidebar = {
		-- You can change the order of elements in the sidebar
		elements = {
			-- Provide as ID strings or tables with "id" and "size" keys
			{
				id = "scopes",
				size = 0.25, -- Can be float or integer > 1
			},
			{ id = "breakpoints", size = 0.25 },
			{ id = "stacks", size = 0.25 },
			{ id = "watches", size = 00.25 },
		},
		size = 40,
		position = "left", -- Can be "left", "right", "top", "bottom"
	},
	tray = {
		elements = { "repl" },
		size = 10,
		position = "bottom", -- Can be "left", "right", "top", "bottom"
	},
	floating = {
		max_height = nil, -- These can be integers or a float between 0 and 1.
		max_width = nil, -- Floats will be treated as percentage of your screen.
		border = "single", -- Border style. Can be "single", "double" or "rounded"
		mappings = {
			close = { "q", "<Esc>" },
		},
	},
	windows = { indent = 1 },
})

local M = {}

local keymap_restore = {}
dap.listeners.after["event_initialized"]["me"] = function()
	for _, buf in pairs(api.nvim_list_bufs()) do
		local keymaps = api.nvim_buf_get_keymap(buf, "n")
		for _, keymap in pairs(keymaps) do
			if keymap.lhs == "K" then
				table.insert(keymap_restore, keymap)
				api.nvim_buf_del_keymap(buf, "n", "K")
			end
		end
	end
	api.nvim_set_keymap("n", "K", '<Cmd>lua require("dap.ui.variables").hover()<CR>', { silent = true })
end

dap.listeners.after["event_terminated"]["me"] = function()
	for _, keymap in pairs(keymap_restore) do
		api.nvim_buf_set_keymap(keymap.buffer, keymap.mode, keymap.lhs, keymap.rhs, { silent = keymap.silent == 1 })
	end
	keymap_restore = {}
end

function M.reload_continue()
	package.loaded["dap_config"] = nil
	require("dap_config")
	dap.continue()
end

local opts = { noremap = false, silent = true }

vim.api.nvim_buf_set_keymap(0, "n", "<leader>db", '<cmd>lua require("dap").toggle_breakpoint()<cr>', opts)
vim.api.nvim_buf_set_keymap(0, "n", "<leader>ds", '<cmd>lua require("dap").step_over()<cr>', opts)
vim.api.nvim_buf_set_keymap(0, "n", "<leader>di", '<cmd>lua require("dap").step_into()<cr>', opts)
vim.api.nvim_buf_set_keymap(0, "n", "<leader>dr", '<cmd>lua require("dap").repl.open()<cr>', opts)
vim.api.nvim_buf_set_keymap(0, "n", "<leader>dc", '<cmd>lua require("dap").continue()<cr>', opts)
vim.api.nvim_buf_set_keymap(0, "n", "<leader>dC", '<cmd>lua require("tudders.dap").reload_continue()<cr>', opts)

-- DAP UI
vim.api.nvim_buf_set_keymap(0, "n", "<leader>du", '<cmd>lua require("dapui").toggle()<cr>', opts)
vim.api.nvim_buf_set_keymap(0, "n", "<leader>de", '<cmd>lua require("dapui").eval()<cr>', opts)

-- Python
dap.adapters.python = {
	type = "executable",
	command = "~/build/debugpy-venv/bin/python",
	args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
	{
		-- The first three options are required by nvim-dap
		type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
		request = "launch",
		name = "Launch file",

		-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

		program = "${workspaceFolder}/${file}", -- This configuration will launch the current file if used.
		pythonPath = function()
			-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
			-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
			-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
			local cwd = vim.fn.getcwd()
			if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
				return cwd .. "/venv/bin/python"
			elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
				return cwd .. "/.venv/bin/python"
			elseif vim.fn.executable(cwd .. "/../venv/bin/python") == 1 then
				return cwd .. "/../venv/bin/python"
			else
				return "/usr/bin/python"
			end
		end,
	},
}

-- C/C++/Rust
local lldb_env = function()
	local variables = {}
	for k, v in pairs(vim.fn.environ()) do
		table.insert(variables, string.format("%s=%s", k, v))
	end
	return variables
end

dap.adapters.lldb = {
	type = "executable",
	command = "~/.local/bin/lldb-vscode", -- adjust as needed
	name = "lldb",
}

dap.configurations.cpp = {
	{
		name = "Launch",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		env = lldb_env,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},

		-- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
		--
		--		echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
		--
		-- Otherwise you might get the following error:
		--
		--		Error on launch: Failed to attach to the target process
		--
		-- But you should be aware of the implications:
		-- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
		runInTerminal = false,
	},
	{
		name = "Attach to process",
		type = "lldb",
		request = "attach",
		pid = require("dap.utils").pick_process,
		args = {},
		-- If you get an "Operation not permitted" error using this, try disabling YAMA:
		--	echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
	},
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

return M
