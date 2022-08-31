-- Expose the module to the outside
local M = {}
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
function on_attach(client, bufnr)

	-- require('folding').on_attach()

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', '<leader>lcc', "<cmd>lua vim.lsp.codelens.run()<CR>", opts)
	buf_set_keymap('n', '<leader>lcr', "<cmd>lua vim.lsp.codelens.refresh()<CR>", opts)
  buf_set_keymap('n', '<leader>lD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>ln', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- buf_set_keymap('n', '<leader>le', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<leader>ldn', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<leader>ldp', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  -- buf_set_keymap('n', '<leader>lq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format {async = true}<CR>", opts)
  buf_set_keymap('n', '<leader>lo', "<cmd>Telescope lsp_workspace_symbols<CR>", opts)


  buf_set_keymap('n', '<leader>lr', "<cmd>Telescope lsp_references<CR>", opts)
  buf_set_keymap('n', '<A-o>', "<cmd>Telescope lsp_document_symbols<CR>", opts)
  -- buf_set_keymap('n', '<leader>la', "<cmd>lua require('telescope.builtin').lsp_code_actions()<CR>", opts)
  buf_set_keymap('n', '<leader>ldd', "<cmd>Telescope diagnostics<CR>", opts)
  -- buf_set_keymap('n', '<leader>ldw', "<cmd>lua require('telescope.builtin').lsp_workspace_diagnostics()<CR>", opts)

  local wk = require("which-key")

				wk.register({
								l = {
												name = "Language Server",
												a = "Code Action",
												c = {
														name = "Code Lense",
														c = "Run Codelens",
														r = "Refrse Codelens",
												},
												d = {
																name = "Diagnostics",
																d = "Document Diagnostics",
																n = "Next diagnostic",
																p = "Previous diagnostic",
																-- w = "Workspace Diagnostics",

												},
												D =  "Type Definition" ,
												-- e =  "Show line diagnostic" ,
												f =  "Formatting" ,
												n =  "Rename" ,
												o =  "Workspace Symbols",
												r =  "References" ,
								},
				}, {prefix= "<leader>"}) 

	require('lsp-status').on_attach(client)
end

-- Register the lsp satus
local lsp_status = require('lsp-status')
lsp_status.register_progress()


-- Add snippet support
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
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
local servers = { "clangd", "gdscript", "pyright", "tsserver", "bashls"}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
		capabilities = capabilities
  }
end

M.on_attach = on_attach
M.capabilities = capabilities

return M
