local nvim_lsp = require("lspconfig")
local nvim_status = require("lsp-status")

local lsp_opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<cr>", lsp_opts)
vim.api.nvim_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", lsp_opts)
vim.api.nvim_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", lsp_opts)
vim.api.nvim_set_keymap("n", "<leader>q", "<cmd>lua vim..diagnostic.setloclist()<cr>", lsp_opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local M = {}
M.on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end
	--Enable completion triggered by <c-x><c-o>
	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", lsp_opts)
	buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", lsp_opts)
	buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", lsp_opts)
	buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", lsp_opts)
	buf_set_keymap("n", "<leader>k", "<cmd>lua vim.lsp.buf.signature_help()<cr>", lsp_opts)
	buf_set_keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", lsp_opts)
	buf_set_keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", lsp_opts)
	buf_set_keymap("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", lsp_opts)
	buf_set_keymap("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<cr>", lsp_opts)
	buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", lsp_opts)
	buf_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", lsp_opts)
	buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", lsp_opts)
	-- buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<cr>", lsp_opts)
	buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.format({async=true})<cr>", lsp_opts)

end

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.codeLens = { dynamicRegistration = false }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = false

-- LSP: Others
-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "clangd", "texlab", "bashls", "html", "tsserver", "jdtls"}--, "lua_ls"} --"rust_analyzer"}
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup({
		on_attach = M.on_attach,
		capabilities = capabilities,
		flags = {
			debounce_text_changes = 150,
		},
	})
end

-- -- -- LSP: Language Tool latex
--  nvim_lsp.ltex.setup{
-- 	on_attach = M.on_attach,
-- 	capabilities = updated_capabilities,
-- 	cmd = {'ltex_ls'},
-- 		 flags = {
-- 			 debounce_text_changes = 150,
-- 		 }
--  }

-- LSP: Tailwind
nvim_lsp.tailwindcss.setup({
	on_attach = M.on_attach,
	capabilities = capabilities,
	filetypes = {
		"aspnetcorerazor", "astro", "astro-markdown", "blade", "clojure", "django-html", "htmldjango",
		"edge", "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", "haml", "handlebars", "hbs", "html",
		"html-eex", "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks",
		"php", "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss",
		"javascript", "javascriptreact", "reason", "rescript", "typescript", "typescriptreact", "vue",
		"svelte", "rust",
	},
	init_options = {
		userLanguages = {
			elixir = "phoenix-heex",
			eruby = "erb",
			heex = "phoenix-heex",
			svelte = "html",
			rust = "html",
		},
	},
	settings = { },
})
-- LSP: Go
nvim_lsp.gopls.setup({
	on_attach = M.on_attach,
	capabilities = capabilities,
	cmd = { "gopls", "serve" },
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
})

-- LSP: C/C++
nvim_lsp.clangd.setup({
	on_attach = M.on_attach,
	capabilities = capabilities,
	cmd = { "clangd", "--clang-tidy" },
	flags = {
		debounce_text_changes = 150,
	},
})

-- LSP: Python
nvim_lsp.pylsp.setup({
	on_attach = M.on_attach,
	capabilities = capabilities,
	flags = {
		debounce_text_changes = 150,
	},
	settings = {
		pylsp = {
			-- configurationSources = {"pylint", "flake8", "pycodestyle", "pydocstyle", "mypy"},
			configurationSources = {"ruff" , "mypy", "black"},
			plugins = {
				-- flake8 = { enabled = true },
				-- set pyltint executable so that it will use the one in a virtual env if it exists
				-- pylint = { enabled = true, executable="pylint"},
				-- pydocstyle = { enabled = true },
				-- pycodestyle = { enabled = false },
				black = { enabled = true },
				mypy = { enabled = true },
				ruff = { enabled = true },
				-- rope_autoimport = { enabled = true },
			},
		}
	}
})

-- might be outdated
-- LSP: Lua
-- USER = vim.fn.expand("$USER")
--
-- local sumneko_binary = "/home/" .. USER .. "/build/lua-language-server/bin/Linux/lua-language-server"
-- local sumneko_root_path = "/home/" .. USER .. "/build/lua-language-server"
--
-- require("lspconfig").sumneko_lua.setup({
-- 	on_attach = M.on_attach,
-- 	capabilities = capabilities,
-- 	flags = {
-- 		debounce_text_changes = 150,
-- 	},
-- 	cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
-- 	settings = {
-- 		Lua = {
-- 			runtime = {
-- 				version = "LuaJIT",
-- 				path = vim.split(package.path, ";"),
-- 			},
-- 			diagnostics = {
-- 				globals = { "vim" },
-- 			},
-- 			workspace = {
-- 				library = {
-- 					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
-- 					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
-- 				},
-- 			},
-- 		},
-- 	},
-- })

return M
