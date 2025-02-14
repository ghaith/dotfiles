return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = true,
    keys = {
      { '<leader>tt', ':ToggleTerm<CR>', { noremap = true, silent = true }, desc = 'Toggle terminal' },
      { '<leader>tv', ':ToggleTerm size=100 direction=vertical<CR>', { noremap = true, silent = true }, desc = 'Toggle terimal vertically' },
    },
  },
}
