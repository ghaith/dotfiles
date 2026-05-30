-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `opts` key (recommended), the configuration runs
-- after the plugin has been loaded as `require(MODULE).setup(opts)`.

return {
	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		opts = {
			-- delay between pressing a key and opening which-key (milliseconds)
			-- this setting is independent of vim.opt.timeoutlen
			delay = 0,
			icons = {
				-- set icon mappings to true if you have a Nerd Font
				mappings = vim.g.have_nerd_font,
				-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
				-- default which-key.nvim defined Nerd Font icons, otherwise define a string table
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},

			-- Document existing key chains
			spec = {
				{ "<leader>c", group = "[C]ode", mode = { "n", "x" } },
				{ "<leader>d", group = "[D]ocument" },
				{ "<leader>r", group = "[R]ename / Review" },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>u", group = "[U]tility" },
				{ "<leader>ul", group = "Spell [L]anguage" },
				{ "<leader>uw", group = "[W]riting" },
				{ "<leader>uwt", group = "[T]ypos" },
				{ "<leader>w", group = "Tmux [W]orkflow" },
				{ "<leader>wv", desc = "Open tmux [V]ertical editor split" },
				{ "<leader>wh", desc = "Open tmux [H]orizontal editor split" },
				{ "<leader>wz", desc = "Toggle centered scratch terminal" },
				{ "<leader>rv", group = "Re[V]iew" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
				{ "<leader>gr", group = "[G]it [R]eview (raw plugin keys)" },
				{ "<leader>gt", group = "Gi[t]ea (tea CLI)" },
			},
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)

			local set_spelllang = function(lang, label)
				vim.opt_local.spell = true
				vim.opt_local.spelllang = lang
				vim.notify(string.format("spelllang=%s (%s)", lang, label))
			end

			local toggle_harper = function()
				local bufnr = vim.api.nvim_get_current_buf()
				local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "harper_ls" })
				if #clients > 0 then
					for _, client in ipairs(clients) do
						vim.lsp.buf_detach_client(bufnr, client.id)
					end
					vim.notify("Harper detached from current buffer")
					return
				end

				if vim.fn.executable("harper-ls") == 0 then
					vim.notify("harper-ls not found on PATH", vim.log.levels.WARN)
					return
				end

				vim.lsp.start({
					name = "harper_ls",
					cmd = { "harper-ls", "--stdio" },
					root_dir = vim.fs.root(bufnr, { ".harper-dictionary.txt", ".git" }) or vim.fn.getcwd(),
					single_file_support = true,
				})
				vim.notify("Harper attached to current buffer")
			end

			local run_typos = function(scope)
				if vim.fn.executable("typos") == 0 then
					vim.notify("typos not found on PATH", vim.log.levels.WARN)
					return
				end

				local target = scope == "file" and vim.fn.expand("%:p") or vim.fn.getcwd()
				if scope == "file" and target == "" then
					vim.notify("Current buffer has no file on disk", vim.log.levels.WARN)
					return
				end

				vim.cmd("botright split")
				vim.cmd("resize 12")
				vim.cmd(string.format("terminal typos %s", vim.fn.shellescape(target)))
			end

			vim.keymap.set("n", "<leader>us", function()
				vim.opt_local.spell = not vim.opt_local.spell:get()
			end, { desc = "Toggle [S]pell" })
			vim.keymap.set("n", "<leader>ule", function()
				set_spelllang("en", "English")
			end, { desc = "Use [E]nglish spellcheck" })
			vim.keymap.set("n", "<leader>uld", function()
				set_spelllang("de", "German")
			end, { desc = "Use [D]eutsch spellcheck" })
			vim.keymap.set("n", "<leader>ulf", function()
				set_spelllang("fr", "French")
			end, { desc = "Use [F]rench spellcheck" })
			vim.keymap.set("n", "<leader>uln", function()
				set_spelllang("nl", "Dutch")
			end, { desc = "Use Du[t]ch spellcheck" })
			vim.keymap.set("n", "<leader>uls", function()
				set_spelllang("es", "Spanish")
			end, { desc = "Use [S]panish spellcheck" })
			vim.keymap.set("n", "<leader>uwh", toggle_harper, { desc = "Toggle [H]arper for buffer" })
			vim.keymap.set("n", "<leader>uwtf", function()
				run_typos("file")
			end, { desc = "Run typos on current [F]ile" })
			vim.keymap.set("n", "<leader>uwtr", function()
				run_typos("repo")
			end, { desc = "Run typos on current [R]epo" })

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "gitcommit", "markdown", "text", "vimwiki" },
				callback = function()
					vim.opt_local.spell = true
					vim.opt_local.spelllang = "en"
				end,
			})
		end,
	},
}
-- vim: ts=2 sts=2 sw=2 et
