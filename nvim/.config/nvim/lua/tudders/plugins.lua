vim.cmd [[packadd packer.nvim]]
vim.cmd [[packadd vimball]]

local has = function(x)
  return vim.fn.has(x) == 1
end

local is_wsl = (function()
  local output = vim.fn.systemlist 'uname -r'
  return not not string.find(output[1] or '', 'WSL')
end)()

return require('packer').startup {
  function(use)
    -- use plugins from this machine
    -- specifying first and second will download as normal if no local copy
    local local_use = function(first, second, opts)
      opts = opts or {}

      local plug_path, home
      if second == nil then
        plug_path = first
        home = 'mark'
      else
        plug_path = second
        home = first
      end

      if vim.fn.isdirectory(vim.fn.expand('~/plugins/' .. plug_path)) == 1 then
        opts[1] = '~/plugins/' .. plug_path
      else
        opts[1] = string.format('%s/%s', home, plug_path)
      end

      use(opts)
    end

    local py_use = function(opts)
      if not has 'python3' then
        return
      end

      use(opts)
    end

    use 'wbthomason/packer.nvim'
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'

    use 'projekt0n/github-nvim-theme'

    -- use 'airblade/vim-gitgutter'
    use {
      'lewis6991/gitsigns.nvim',
      requires = {
        'nvim-lua/plenary.nvim'
      }
    }
    use 'octol/vim-cpp-enhanced-highlight'
    -- use 'tpope/vim-markdown' -- TODO use LSP markdown
    use 'tpope/vim-fugitive'
    use 'tpope/vim-eunuch'
    use 'roxma/vim-paste-easy'
    use 'tpope/vim-obsession'
    use 'ap/vim-css-color'
    use 'wikitopian/hardmode'
		use 'mbbill/undotree'
    -- use 'folke/which-key.nvim'

    use {
      'hoob3rt/lualine.nvim',
      requires = {
        'kyazdani42/nvim-web-devicons', opt = true
      }
    }

    use {
      'ThePrimeagen/git-worktree.nvim',
      config = function()
        require('git-worktree').setup {}
      end,
    }
    use 'ThePrimeagen/harpoon'
    use 'ThePrimeagen/refactoring.nvim'

		use 'bkad/CamelCaseMotion'

    use {
      'folke/zen-mode.nvim',
      config = function()
        require('zen-mode').setup()
      end,
    }

		use '8ooo8/leetcode'

    -- TJ's Plugins
    -- local_use 'nlua.nvim'
    -- local_use 'vim9jit'
    -- local_use 'colorbuddy.nvim'
    -- local_use 'gruvbuddy.nvim'
    -- local_use 'apyrori.nvim'
    -- local_use 'manillua.nvim'
    -- local_use 'cyclist.vim'
    -- local_use 'express_line.nvim'
    -- local_use 'overlength.vim'
    -- local_use 'pastery.vim'
    -- local_use 'complextras.nvim'
    -- local_use('tjdevries', 'astronauta.nvim', {
    --   setup = function()
    --     vim.g.astronauta_load_plugins = false
    --   end,
    -- })

    -- Contributor Plugins
    -- local_use('L3MON4D3', 'LuaSnip')

    -- When I have some extra time...
    -- local_use 'train.vim'
    -- local_use 'command_and_conquer.nvim'
    -- local_use 'streamer.nvim'
    -- local_use 'bandaid.nvim'

    -- LSP Plugins:

    -- NOTE: lspconfig ONLY has configs, for people reading this :)
    use 'neovim/nvim-lspconfig'
    use 'wbthomason/lsp-status.nvim'

    use {
      'folke/lsp-trouble.nvim',
      cmd = 'LspTrouble',
      config = function()
        require('trouble').setup {
          auto_preview = false,
          auto_fold = true,
        }
      end,
    }

    -- local_use 'lsp_extensions.nvim'
    -- use 'glepnir/lspsaga.nvim'
    -- use 'onsails/lspkind-nvim'
    -- https://github.com/rmagatti/goto-preview

    -- TODO: Investigate
    -- use 'jose-elias-alvarez/nvim-lsp-ts-utils'

    -- Telescope stuff
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-telescope/telescope-fzf-writer.nvim'
    use 'nvim-telescope/telescope-packer.nvim'
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    -- use 'nvim-telescope/telescope-fzy-native.nvim'
    -- use 'nvim-telescope/telescope-async-sorter-test.nvim'
    
    -- Frecency is a different finder based on frequency + recency
    -- use  {
    --   'nvim-telescope/telescope-frecency.nvim',
    --   requires = {
    --     'tami5/sql.nvim',
    --     'nvim-telescope/telescope.nvim',
    --   },
    --   config = function()
    --    require('telescope').load_extension('frecency')
    --   end
    -- }
    -- use 'nvim-telescope/telescope-github.nvim'
    use 'nvim-telescope/telescope-symbols.nvim'

    -- TODO: When i'm back w/ some npm stuff, get this working.
    -- elianiva/telescope-npm.nvim

    -- local_use 'telescope-hacks.nvim'
    -- local_use 'telescope-sourcegraph.nvim'
    -- local_use 'green_light.nvim'

    -- use 'nvim-telescope/telescope-cheat.nvim'
    -- use { 'nvim-telescope/telescope-arecibo.nvim', rocks = { 'openssl', 'lua-http-parser' } }

    -- use {
    --   'antoinemadec/FixCursorHold.nvim',
    --   run = function()
    --     vim.g.curshold_updatime = 1000
    --   end,
    -- }

    -- use 'nanotee/luv-vimdocs'
    -- use 'milisims/nvim-luaref'

    -- PRACTICE:
    -- use {
    --   'tpope/vim-projectionist', -- STREAM: Alternate file editting and some helpful stuff,
    --   enable = false,
    -- }

    -- For narrowing regions of text to look at them alone
    -- use {
    --   'chrisbra/NrrwRgn',
    --   cmd = { 'NarrowRegion', 'NarrowWindow' },
    -- }

    -- use 'tweekmonster/spellrotate.vim'
    -- use 'haya14busa/vim-metarepeat' -- Never figured out how to use this, but looks like fun.

    -- VIM EDITOR:

    -- Little know features:
    --   :SSave
    --   :SLoad
    --       These are wrappers for mksession that work great. I never have to use
    --       mksession anymore or worry about where things are saved / loaded from.
    -- use {
    --   'mhinz/vim-startify',
    --   cmd = { 'SLoad', 'SSave' },
    --   config = function()
    --     vim.g.startify_disable_at_vimenter = true
    --   end,
    -- }

    -- Better profiling output for startup.
    use {
      'dstein64/vim-startuptime',
      cmd = 'StartupTime',
    }

    -- Pretty colors
    use 'norcalli/nvim-colorizer.lua'
    use {
      'norcalli/nvim-terminal.lua',
      config = function()
        require('terminal').setup()
      end,
    }

    -- Make comments appear IN YO FACE
    use {
      'tjdevries/vim-inyoface',
      config = function()
        vim.api.nvim_set_keymap('n', '<leader>cc', '<Plug>(InYoFace_Toggle)', {})
      end,
    }

    -- Show only what you're searching for.
    -- STREAM: Could probably make this a bit better. Definitely needs docs
    -- use 'tjdevries/fold_search.vim'

    -- use {
    --   'tweekmonster/haunted.vim',
    --   cmd = 'Haunt',
    --  }

    -- use {
    --   'tpope/vim-scriptease',
    --   cmd = {
    --     'Messages', --view messages in quickfix list
    --     'Verbose', -- view verbose output in preview window.
    --     'Time', -- measure how long it takes to run some stuff.
    --   },
    -- }

    -- Quickfix enhancements. See :help vim-qf
    -- use 'romainl/vim-qf'

    -- use {
    --   'glacambre/firenvim',
    --   run = function()
    --     vim.fn['firenvim#install'](0)
    --   end,
    -- }

    -- TODO: Eventually statusline should consume this.
    use 'mkitt/tabline.vim'

    use 'kyazdani42/nvim-web-devicons'
    if not is_wsl then
      use 'yamatsum/nvim-web-nonicons'
    end

    -- use { 'Shougo/defx.nvim', }
    use 'kyazdani42/nvim-tree.lua'
    -- use 'lambdalisue/vim-protocol'

    -- Undo helper
    --use 'sjl/gundo.vim'

    -- TODO: This randomly disappeared? Find a replacement sometime.
    -- Make cool signs for your files
    -- use 'johannesthyssen/vim-signit'

    -- Crazy good box drawing
    use 'gyim/vim-boxdraw'

    -- Better increment/decrement
    use 'monaqa/dial.nvim'

    --   FOCUSING:
    -- use {
    --  'junegunn/goyo.vim',
    -- cmd = 'Goyo',
    -- }

    -- use {
    --  'junegunn/limelight.vim',
    --  after = 'goyo.vim',
    -- }

    --
    --
    --  LANGUAGE:
    -- TODO: Should check on these if they are the best ones
    -- use { 'neovimhaskell/haskell-vim', ft = 'haskell' }
    -- use { 'elzr/vim-json', ft = 'json' }
    -- use { 'goodell/vim-mscgen', ft = 'mscgen' }
    -- use 'PProvost/vim-ps1'
    -- use 'Glench/Vim-Jinja2-Syntax'
    -- use 'justinmk/vim-syntax-extra'

    -- use 'pearofducks/ansible-vim'
    -- use { 'cespare/vim-toml', ft = 'toml' }

    -- use { 'ziglang/zig.vim', ft = 'zig' }
    -- use { 'JuliaEditorSupport/julia-vim', ft = 'julia' }

    use { 'iamcco/markdown-preview.nvim', ft = 'markdown', run = 'cd app && yarn install' }

    -- Typescript
    if false then
      use 'jelera/vim-javascript-syntax'
      use 'othree/javascript-libraries-syntax.vim'
      use 'leafgarland/typescript-vim'
      use 'peitalin/vim-jsx-typescript'

      use { 'vim-scripts/JavaScript-Indent', ft = 'javascript' }
      use { 'pangloss/vim-javascript', ft = { 'javascript', 'html' } }

      -- Godot
      use 'habamax/vim-godot'
      --
    end

    -- Wonder if I can make LSP do this and respect .prettier files.
    --  I don't write enough typescript to think about this.
    --   use {
    --    'prettier/vim-prettier',
    --   ft = { 'html', 'javascript', 'typescript' },
    --   run = 'yarn install',
    -- }

    -- TODO: Turn emmet back on when I someday use it
    -- use 'mattn/emmet-vim'

    use 'tpope/vim-liquid'
    --
    -- Lisp
    -- use { 'eraserhd/parinfer-rust', run = 'cargo build --release' }
    --
    --
    -- LSP

    -- STREAM: Figure out how to use snippets better
    -- use 'haorenW1025/completion-nvim'
    use 'hrsh7th/nvim-compe'

    -- Completion stuff
    -- local_use 'rofl.nvim'

    -- use 'hrsh7th/vim-vsnip'
    -- use 'hrsh7th/vim-vsnip-integ'
    -- use 'norcalli/snippets.nvim'

    -- Cool tags based viewer
    --   :Vista  <-- Opens up a really cool sidebar with info about file.
    use { 'liuchengxu/vista.vim', cmd = 'Vista' }

    -- Find and replace
    --    py_use 'brooth/far.vim'

    -- Debug adapter protocol
    --   Have not yet checked this out, but looks awesome.
    -- use 'puremourning/vimspector'
    --    use 'mfussenegger/nvim-dap'
    --   use 'theHamsta/nvim-dap-virtual-text'
    --   use 'mfussenegger/nvim-dap-python'
    --  use 'nvim-telescope/telescope-dap.nvim'
    -- Pocco81/DAPInstall.nvim

    --   use 'jbyuki/one-small-step-for-vimkind'

    --    use {
    --     'rcarriga/vim-ultest',
    --
    --     requires = { 'vim-test/vim-test' },
    --    run = ':UpdateRemotePlugins',
    --   cond = function()
    --    return vim.fn.has 'python3' == 1
    -- end,
    --  config = function()
    --   vim.cmd [[nmap ]t <Plug>(ultest-next-fail)]]
    --   vim.cmd [[nmap [t <Plug>(ultest-prev-fail)]]
    -- end,
    -- }

    --   use {
    --      'alfredodeza/pytest.vim',
    --     cond = function()
    --       return vim.fn.has 'python3' == 1
    --     end,
    --   }

    if false and has 'python3' then
      use 'puremourning/vimspector'
    end
    --

    -- TREE SITTER:
    -- local_use('nvim-treesitter', 'nvim-treesitter')
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'nvim-treesitter/playground'
    use 'vigoux/architext.nvim'

    -- use 'JoosepAlviste/nvim-ts-context-commentstring'
    -- use {
    --   'romgrk/nvim-treesitter-context',
    --   config = function()
    --     require('treesitter-context.config').setup {
    --       enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    --     }

    --     -- TODO: Decide on a better highlighting color
    --     -- vim.cmd [[highlight TreesitterContext link NormalFloat]]
    --   end,
    -- }

    -- Grammars
    -- local_use 'tree-sitter-lua'
    -- local_use 'tree-sitter-sql'

    --
    -- NAVIGATION:
    -- STREAM: Show off edit_alternate.vim
    --  use 'tjdevries/edit_alternate.vim'

    --  use 'google/vim-searchindex'

    -- use 'tamago324/lir.nvim'
    --  use 'tamago324/lir-git-status.nvim'

    -- use 'pechorin/any-jump.vim'

    --
    -- TEXT MANIUPLATION
    --    use 'godlygeek/tabular' -- Quickly align text by pattern
    use 'tpope/vim-commentary' -- Easily comment out lines or objects
    --    use 'tpope/vim-repeat' -- Repeat actions better
    --   use 'tpope/vim-abolish' -- Cool things with words!
    --   use 'tpope/vim-characterize'
    --   use { 'tpope/vim-dispatch', cmd = { 'Dispatch', 'Make' } }

    --    use {
    --     'AndrewRadev/splitjoin.vim',
    --    keys = { 'gJ', 'gS' },
    -- }

    -- TODO: Check out macvhakann/vim-sandwich at some point
    --   use 'tpope/vim-surround' -- Surround text objects easily

    --
    -- GIT:
    use 'TimUntersberger/neogit'

    -- Github integration
    --  if vim.fn.executable 'gh' == 1 then
    --    use 'pwntester/octo.nvim'
    --   end
    --   use 'ruifm/gitlinker.nvim'

    -- Sweet message committer
    use 'rhysd/committia.vim'
    use 'sindrets/diffview.nvim'

    -- Floating windows are awesome :)
    --  use {
    --   'rhysd/git-messenger.vim',
    --  keys = '<Plug>(git-messenger)',
    --  }

    -- use 'untitled-ai/jupyter_ascending.vim'

    --  use 'tjdevries/standard.vim'
    -- use 'tjdevries/conf.vim'

    use { 'junegunn/fzf', run = './install --all' }
    use { 'junegunn/fzf.vim' }

    if false and vim.fn.executable 'neuron' == 1 then
      use {
        'oberblastmeister/neuron.nvim',
        branch = 'unstable',
        config = function()
          -- these are all the default values
          require('neuron').setup {
            virtual_titles = true,
            mappings = true,
            run = nil,
            neuron_dir = '~/neuron',
            leader = 'gz',
          }
        end,
      }
    end

    -- use {
    --   'alec-gibson/nvim-tetris',
    --   cmd = 'Tetris',
    --  }

    -- TODO: Figure out why this randomly popups
    --       Figure out if I want to use it later as well :)
    -- use {
    --   'folke/which-key.nvim',
    --   config = function()
    --     -- TODO: Consider changing my timeoutlen?
    --     require('which-key').setup {
    --       presets = {
    --         g = true,
    --       },
    --     }
    --   end,
    -- }

    -- It would be fun to think about making a wiki again...
    -- local_use 'wander.nvim'
    -- local_use 'riki.nvim'

    -- pretty sure I'm done w/ these
    -- local_use 'vlog.nvim'
  end,

  config = {
    display = {
      -- open_fn = require('packer.util').float,
    },
  },
}

--[[ Replacements Needed
' Plug 'https://github.com/AndrewRadev/linediff.vim'
' Plug 'https://github.com/AndrewRadev/switch.vim'
Plu 'plasticboy/vim-markdown', { 'for': 'markdown' }
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_fenced_languages = [
\ 'python=python',
\ 'json=json',
\ ]
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}
-- Should get a test helper.
Plug 'alfredodeza/pytest.vim'
-- completes issue names in commit messages
Plug 'tpope/vim-rhubarb'
-- Create menus easily.
Plug 'skywind3000/quickmenu.vim'
-- Indentation guides
Plug 'nathanaelkane/vim-indent-guides'                       ' See indentation guides
--]]
