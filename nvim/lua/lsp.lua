-- Expose the module to the outside
local M = {}
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
function on_attach(client, bufnr)

  -- Mappings.
	local telescope = require('telescope.builtin')

  -- See `:help vim.lsp.*` for documentation on any of the below functions
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { noremap=true, silent=true, desc="Goto declaration" })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap=true, silent=true, desc="Goto definition"})
  vim.keymap.set('n', 'gr', telescope.lsp_references, { noremap=true, silent=true, desc="Find references"})
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, {noremap=true, silent=true, desc="Hover Info"})
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {noremap=true, silent=true, desc="Goto implementation"})
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, {noremap=true, silent=true, desc="Signature Help"})
	vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, {noremap=true, silent=true, desc="Code Action"})
	vim.keymap.set('n', '<leader>lcc', vim.lsp.codelens.run, {noremap=true, silent=true, desc="Run codelens"})
	vim.keymap.set('n', '<leader>lcr', vim.lsp.codelens.refresh, {noremap=true, silent=true, desc="Refresh codelens"})
  vim.keymap.set('n', '<leader>lD', vim.lsp.buf.type_definition, {noremap=true, silent=true, desc="Type Definition"})
  vim.keymap.set('n', '<leader>ln', vim.lsp.buf.rename, {noremap=true, silent=true, desc="Rename"})
  vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, {noremap=true, silent=true, desc="Show line diagnostics"})
  vim.keymap.set('n', '<leader>ldn', vim.diagnostic.goto_prev, {noremap=true, silent=true, desc="Next diagnostic"})
  vim.keymap.set('n', '<leader>ldp', vim.diagnostic.goto_next, {noremap=true, silent=true, desc="Previous diagnostic"})
  -- vim.keymap.set('n', '<leader>lq', vim.lsp.diagnostic.set_loclist(), opts)
  vim.keymap.set("n", "<leader>lf", function () vim.lsp.buf.format {async = true} end, {noremap=true, silent=true, desc="Format"})


  vim.keymap.set('n', '<leader>ls', telescope.lsp_document_symbols, {noremap=true, silent=true, desc="Document Symbols"})
  vim.keymap.set('n', '<leader>lS', telescope.lsp_workspace_symbols, {noremap=true, silent=true, desc="Workspace Symbols"})
  vim.keymap.set('n', '<leader>ldd', telescope.diagnostics, {noremap=true, silent=true, desc="Document Diagnostics"})

	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local wk = require("which-key")

	wk.add({
    { "<leader>l", group = "Language Server" },
    { "<leader>lc", group = "Code Lense" },
    { "<leader>ld", group = "Diagnostics" },
  })

	require('lsp-status').on_attach(client)
end

-- Register the lsp satus
local lsp_status = require('lsp-status')
lsp_status.register_progress()


-- Add snippet and completion support
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

local nvim_lsp = require('lspconfig')

capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- "tsserver", 
local servers = { "bashls", "dockerls", "taplo", "marksman", "pylsp"}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
		capabilities = capabilities
  }
end

-- Lua LSP plugin needs different config
require'lspconfig'.lua_ls.setup {
	flags = {
		debounce_text_changes = 150,
	},
	capabilities = capabilities,
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT'
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            }
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            -- library = vim.api.nvim_get_runtime_file("", true)
          }
        }
      })

      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
    return true
  end
}

M.on_attach = on_attach
M.capabilities = capabilities

return M
