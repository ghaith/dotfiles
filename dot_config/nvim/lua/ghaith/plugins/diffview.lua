-- Diffview.nvim: forge-agnostic diff and file-history viewer.
-- Use it to review any branch/commit locally (Gerrit changes, fetched PRs, etc).
return {
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory', 'DiffviewRefresh', 'DiffviewToggleFiles' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      enhanced_diff_hl = true,
      view = {
        merge_tool = { layout = 'diff3_mixed' },
      },
    },
    keys = {
      { '<leader>grd', '<cmd>DiffviewOpen<cr>',          desc = 'Diffview: open' },
      { '<leader>grD', '<cmd>DiffviewClose<cr>',         desc = 'Diffview: close' },
      { '<leader>grh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Diffview: file history' },
      { '<leader>grH', '<cmd>DiffviewFileHistory<cr>',   desc = 'Diffview: repo history' },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
