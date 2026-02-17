return {
  'olimorris/codecompanion.nvim',
  version = '^18.0.0',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    vim.keymap.set('n', '<leader>ai', function()
      require('codecompanion').actions {}
    end, { desc = 'Trigger code companion actions' }),
    vim.keymap.set('n', '<C-s>', function()
      require('codecompanion').inline {}
    end, { desc = 'Trigger inline code assist' }),
  },
}
