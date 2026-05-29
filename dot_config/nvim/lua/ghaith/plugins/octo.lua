-- Octo.nvim: review/comment on GitHub PRs and issues. Auth uses the `gh` CLI
-- (run `gh auth login` once per machine). Gitea reviews intentionally go
-- through `tea` + diffview instead — see ~/pr-review-workflow.md.
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
      { '<leader>grp', '<cmd>Octo pr list<cr>',      desc = 'Octo: list PRs' },
      { '<leader>grP', '<cmd>Octo pr search<cr>',    desc = 'Octo: search PRs' },
      { '<leader>gri', '<cmd>Octo issue list<cr>',   desc = 'Octo: list issues' },
      { '<leader>grI', '<cmd>Octo issue search<cr>', desc = 'Octo: search issues' },
      { '<leader>grs', '<cmd>Octo review start<cr>', desc = 'Octo: start review' },
      { '<leader>grc', '<cmd>Octo review resume<cr>', desc = 'Octo: continue review' },
      { '<leader>gro', ':Octo ',                     desc = 'Octo: command' },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
