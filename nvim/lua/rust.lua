require('lsp')

local opts = {
    tools = { -- rust-tools options
        -- automatically set inlay hints (type hints)
        -- There is an issue due to which the hints are not applied on the first
        -- opened file. For now, write to the file to trigger a reapplication of
        -- the hints or just run :RustSetInlayHints.
        -- default: true
        autoSetHints = true,

        -- whether to show hover actions inside the hover window
        -- this overrides the default hover handler so something like lspsaga.nvim's hover would be overriden by this
        -- default: true
        hover_with_actions = true,

        -- These apply to the default RustRunnables command
        runnables = {
            -- whether to use telescope for selection menu or not
            -- default: true
            use_telescope = true

            -- rest of the opts are forwarded to telescope
        },

        -- These apply to the default RustSetInlayHints command
        inlay_hints = {
            -- wheter to show parameter hints with the inlay hints or not
            -- default: true
            show_parameter_hints = true,

            -- prefix for parameter hints
            -- default: "<-"
            parameter_hints_prefix = "<- ",

            -- prefix for all the other hints (type, chaining)
            -- default: "=>"
            other_hints_prefix = "=> ",

            -- whether to align to the lenght of the longest line in the file
            max_len_align = false,

            -- padding from the left if max_len_align is true
            max_len_align_padding = 1,

            -- whether to align to the extreme right or not
            right_align = false,

            -- padding from the right if right_align is true
            right_align_padding = 7
        },

        hover_actions = {
            -- the border that is used for the hover window
            -- see vim.api.nvim_open_win()
            border = {
                {"╭", "FloatBorder"}, {"─", "FloatBorder"},
                {"╮", "FloatBorder"}, {"│", "FloatBorder"},
                {"╯", "FloatBorder"}, {"─", "FloatBorder"},
                {"╰", "FloatBorder"}, {"│", "FloatBorder"}
            },

            -- whether the hover action window gets automatically focused
            -- default: false
            auto_focus = false
        }
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
						on_attach = on_attach

		} -- rust-analyer options
}

require('rust-tools').setup(opts)

-- Mappings
vimp.nnoremap('<leader>rh', function() 
				require'rust-tools.hover_actions'.hover_actions()
end)
vimp.nnoremap('<leader>rr', function() 
				require('rust-tools.runnables').runnables()
end)
vimp.nnoremap('<leader>rem', function() 
				require'rust-tools.expand_macro'.expand_macro()
end)
vimp.nnoremap('<leader>rmu', function()
				local up = true -- true = move up, false = move down
				require'rust-tools.move_item'.move_item(up)
end)
vimp.nnoremap('<leader>rmd', function()
				local up = false -- true = move up, false = move down
				require'rust-tools.move_item'.move_item(up)
end)
vimp.nnoremap('<leader>rc', function()
				require'rust-tools.open_cargo_toml'.open_cargo_toml()
end)

vimp.nnoremap('<leader>ru', function()
				require'rust-tools.parent_module'.parent_module()
end)
vimp.nnoremap('<leader>rj', function()
				require'rust-tools.join_lines'.join_lines()
end)
vimp.nnoremap('<leader>rd', function()
				require'rust-tools.debuggables'.debuggables()
end)



  local wk = require("which-key")

				wk.register({
								r = {
												name = "Rust Tools",
												c = "Cargo toml",
												d = "Debuggables",
												e = {
																m = "Expand Macro",
												},
												h = "Hover",
												j = "Join Lines",
												m = {
																name = "Move",
																d = "Down",
																u = "Up",
												},
												r = "Runnables",
												u = "Parent Module",
								},
				}, {prefix= "<leader>"}) 

