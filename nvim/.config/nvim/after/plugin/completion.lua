vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Don't show the dumb matching stuff.
vim.opt.shortmess:append("c")

local cmp = require("cmp")

cmp.setup {
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},

	mapping = {
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-e>"] = cmp.mapping.close(),
		-- ["<c-y>"] = cmp.mapping.confirm {
		--	 behavior = cmp.ConfirmBehavior.Insert,
		--	 select = true,
		-- },
		["<Tab>"] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},

		-- TODO: Not sure I'm in love with this one.
		["<C-Space>"] = cmp.mapping.complete(),

		-- These mappings are useless. I already use C-n and C-p correctly.
		-- This simply overrides them and makes them do bad things in other buffers.
		-- ["<C-p>"] = cmp.mapping.select_prev_item(),
		-- ["<C-n>"] = cmp.mapping.select_next_item(),
	},

	sources = {
		{ name = "buffer" },
		{ name = "path" },
		{ name = "nvim_lua" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
}

