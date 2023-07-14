vim.cmd([[packadd packer.nvim]])
vim.cmd([[packadd vimball]])


local has = function(x)
	return vim.fn.has(x) == 1
end

local is_wsl = (function()
	local output = vim.fn.systemlist("uname -r")
	return not not string.find(output[1] or "", "WSL")
end)()

return require("packer").startup({
	function(use)
		-- use plugins from this machine
		-- specifying first and second will download as normal if no local copy
		local local_use = function(first, second, opts)
			opts = opts or {}

			local plug_path, home
			if second == nil then
				plug_path = first
				home = "mark"
			else
				plug_path = second
				home = first
			end

			if vim.fn.isdirectory(vim.fn.expand("~/dev/" .. plug_path)) == 1 then
				opts[1] = "~/dev/" .. plug_path
			else
				opts[1] = string.format("%s/%s", home, plug_path)
			end

			use(opts)
		end

		local py_use = function(opts)
			if not has("python3") then
				return
			end

			use(opts)
		end

		use("wbthomason/packer.nvim")

		-- use("/home/mark/dev/languagetool.nvim.git/master/")
		-- use("vigoux/LanguageTool.nvim")

		use("nvim-lua/popup.nvim")
		use("nvim-lua/plenary.nvim")

		-- themes
		use({
			"projekt0n/github-nvim-theme",
		})

		use({
			"lewis6991/gitsigns.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
			},
		})

		use("github/copilot.vim")

		use("numToStr/Comment.nvim")

		-- use("octol/vim-cpp-enhanced-highlight")
		-- use 'tpope/vim-markdown' -- TODO use LSP markdown
		use("tpope/vim-fugitive")
		use("tpope/vim-eunuch")
		use("roxma/vim-paste-easy")
		-- use("tpope/vim-obsession")
		-- use("ap/vim-css-color")
		use("wikitopian/hardmode")
		use("mbbill/undotree")

		-- Completion
		use("hrsh7th/nvim-cmp")
		use("hrsh7th/cmp-buffer")
		use("hrsh7th/cmp-path")
		use("hrsh7th/cmp-nvim-lua")
		use("hrsh7th/cmp-nvim-lsp")
		use("hrsh7th/cmp-omni")
		use("f3fora/cmp-spell")
		use("petertriho/cmp-git")
		use("kdheepak/cmp-latex-symbols")
		use("saadparwaiz1/cmp_luasnip")

		use("vim-scripts/dbext.vim")


		-- status line
		use({
			"hoob3rt/lualine.nvim",
			requires = {
				"kyazdani42/nvim-web-devicons",
				opt = true,
			},
			opt = false,
		})

		-- DAP
		use("mfussenegger/nvim-dap")
		use("theHamsta/nvim-dap-virtual-text")
		use({
			"rcarriga/nvim-dap-ui",
			requires = { "mfussenegger/nvim-dap" }
		})

		-- use 'ThePrimeagen/vim-apm'
		use("ThePrimeagen/git-worktree.nvim")
		use("ThePrimeagen/harpoon")

		local_use 'refactoring.nvim.git/python'

		use("bkad/CamelCaseMotion")

		-- use({
		-- 	"folke/zen-mode.nvim",
		-- 	config = function()
		-- 		require("zen-mode").setup()
		-- 	end,
		-- })

		-- use("rhysd/vim-grammarous")

		-- latex
		use("lervag/vimtex")
		use("KeitaNakamura/tex-conceal.vim")

		-- Snippets
		use({"L3MON4D3/LuaSnip", requires = {"lervag/vimtex"}})

		-- LSP Plugins
		use("neovim/nvim-lspconfig")
		use("wbthomason/lsp-status.nvim")

		-- use({
		-- 	"folke/lsp-trouble.nvim",
		-- 	cmd = "LspTrouble",
		-- 	config = function()
		-- 		require("trouble").setup({
		-- 			auto_preview = false,
		-- 			auto_fold = true,
		-- 		})
		-- 	end,
		-- })

		use('simrat39/rust-tools.nvim')
		use {'saecki/crates.nvim', requires = {'nvim-lua/plenary.nvim'}}

		-- local_use 'lsp_extensions.nvim'
		-- use 'glepnir/lspsaga.nvim'
		-- use 'onsails/lspkind-nvim'
		-- https://github.com/rmagatti/goto-preview

		-- Telescope stuff
		use {
			'nvim-telescope/telescope.nvim',
			requires = { {'nvim-lua/plenary.nvim'} }
		}
		use("nvim-telescope/telescope-fzf-writer.nvim")
		use("nvim-telescope/telescope-packer.nvim")
		use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
		use("nvim-telescope/telescope-dap.nvim")
		-- use 'nvim-telescope/telescope-fzy-native.nvim'
		-- use 'nvim-telescope/telescope-async-sorter-test.nvim'

		use("nvim-telescope/telescope-github.nvim")
		use("nvim-telescope/telescope-symbols.nvim")

		use("nvim-telescope/telescope-cheat.nvim")

		-- TREE SITTER:
		use("nvim-treesitter/nvim-treesitter")
		use("nvim-treesitter/nvim-treesitter-textobjects")
		use("nvim-treesitter/playground")

		-- Crazy good box drawing
		use("gyim/vim-boxdraw")


		-- use("pearofducks/ansible-vim")
		-- use { 'iamcco/markdown-preview.nvim', ft = 'markdown', run = 'cd app && yarn install' }

		-- Cool tags based viewer
		--	 :Vista  <-- Opens up a really cool sidebar with info about file.
		use({ "liuchengxu/vista.vim", cmd = "Vista" })

		use("rafi/vim-venom")

		use("raimon49/requirements.txt.vim")

		-- Sweet message committer
		use("rhysd/committia.vim")
		use("sindrets/diffview.nvim")

		use("rhysd/git-messenger.vim")

		use({ "junegunn/fzf", run = "./install --all" })
		use({ "junegunn/fzf.vim" })


	end,

	config = {
		display = {
			-- open_fn = require('packer.util').float,
		},
	},
})
