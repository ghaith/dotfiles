local cmp = require'cmp'
local lspkind = require('lspkind')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

cmp.setup({
	window = {
    completion = {
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
      col_offset = -3,
      side_padding = 0,
    },
  },
	snippet = {
		expand = function(args) 
			 require'luasnip'.lsp_expand(args.body)
		end
	},
	sources = cmp.config.sources({
			{ name = "nvim_lsp", priority = 1 },
			{ name = "nvim_lsp_signature_help" },
			{ name = "nvim_lua" },
			{ name = "luasnip" },
			{ name = "git" },
			{ name = "path" },
		}, {
			{name = 'buffer', keyword_length=5}	,
		}),
	mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
		formatting = {
			format = lspkind.cmp_format({
				mode = 'symbol_text', -- show only symbol annotations
				maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

				-- -- The function below will be called before any actual modifications from lspkind
				-- -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
				-- before = function (entry, vim_item)
				-- 	...
				-- 	return vim_item
				-- end
			})
		},
		experimental = {
			-- Use the new menu
			native_menu = false,
			-- Show text in buffer while selecting
			ghost_text = true,
		},
})
cmp.event:on(
	'confirm_done',
	cmp_autopairs.on_confirm_done()
)

-- require("cmp_git").setup()
