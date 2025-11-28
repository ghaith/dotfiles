return {
  'zbirenbaum/copilot.lua',
  dependencies = {
    'copilotlsp-nvim/copilot-lsp',
    init = function()
      vim.g.copilot_nes_debounce = 500
      require('copilot-lsp').setup {
        server_opts_overrides = {
          settings = {
            advanced = {
              inlineSuggestCount = 3,
            },
          },
        },
      }
    end,
  },
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      suggession = {
        keymap = {
          accept = '<leader>ca',
          accept_word = false,
          accept_line = false,
          next = '<leader>cn',
          prev = '<leader>cp',
          dismiss = '<leader>cx',
        },
      },
      nes = {
        enabled = true, -- requires copilot-lsp as a dependency
        auto_trigger = true,
        keymap = {
          accept_and_goto = '<leader>cg',
          accept = '<leader>cna',
          dismiss = '<ledaer>cnx',
        },
      },
    }
  end,
}
