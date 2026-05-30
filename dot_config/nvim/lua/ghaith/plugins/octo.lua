return {
  {
    'pwntester/octo.nvim',
    cmd = 'Octo',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      enable_builtin = true,
      picker = 'telescope',
      default_merge_method = 'squash',
    },
    keys = {
      { '<leader>rvp', '<cmd>Octo pr list<cr>', desc = 'Re[V]iew [P]ull requests' },
      { '<leader>rvs', '<cmd>Octo review start<cr>', desc = 'Re[V]iew [S]tart GitHub review' },
      { '<leader>rvg', ':Octo ', desc = 'Re[V]iew [G]itHub command' },
      { '<leader>grp', '<cmd>Octo pr list<cr>', desc = 'Octo: list PRs' },
      { '<leader>grP', '<cmd>Octo pr search<cr>', desc = 'Octo: search PRs' },
      { '<leader>gri', '<cmd>Octo issue list<cr>', desc = 'Octo: list issues' },
      { '<leader>grI', '<cmd>Octo issue search<cr>', desc = 'Octo: search issues' },
      { '<leader>grs', '<cmd>Octo review start<cr>', desc = 'Octo: start review' },
      { '<leader>grc', '<cmd>Octo review resume<cr>', desc = 'Octo: continue review' },
      { '<leader>gro', ':Octo ', desc = 'Octo: command' },
    },
  },
}
