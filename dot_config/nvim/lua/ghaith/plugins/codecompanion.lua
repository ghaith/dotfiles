return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    adapters = {
      http = {
        llmstudio = function()
          return require('codecompanion.adapters').extend('openai_compatible', {
            name = 'llmstudio',
            env = {
              url = 'http://localhost:1234', -- optional: default value is ollama url http://127.0.0.1:11434
            },
            schema = {
              model = {
                default = 'qwen3-32b',
              },
            },
          })
        end,
      },
    },
    strategies = {
      -- Change the default chat adapter
      chat = {
        adapter = 'copilot',
      },
      inline = {
        adapter = 'copilot',
      },
      cmd = {
        adapter = 'copilot',
      },
    },
    -- Set debug logging
    log_level = 'DEBUG',
    vim.keymap.set('n', '<leader>ai', function()
      require('codecompanion').actions {}
    end, { desc = 'Trigger code companion actions' }),
    vim.keymap.set('n', '<C-s>', function()
      require('codecompanion').inline {}
    end, { desc = 'Trigger inline code assist' }),
  },
}
