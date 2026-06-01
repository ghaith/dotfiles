local function open_branch_review()
  local tmux = require 'ghaith.tmux'
  local base = tmux.git_base_ref()
  vim.cmd('DiffviewOpen ' .. base .. '...HEAD')
end

local function open_last_review()
  vim.cmd 'DiffviewOpen HEAD~1..HEAD'
end

local function open_ref_review()
  local tmux = require 'ghaith.tmux'
  tmux.pick_ref(function(ref)
    vim.cmd('DiffviewOpen ' .. ref .. '...HEAD')
  end)
end

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
      { '<leader>rvb', open_branch_review, desc = 'Re[V]iew [B]ranch vs base' },
      { '<leader>rvl', open_last_review, desc = 'Re[V]iew [L]ast commit' },
      { '<leader>rvr', open_ref_review, desc = 'Re[V]iew against [R]ef' },
      { '<leader>rvf', '<cmd>DiffviewFileHistory %<cr>', desc = 'Re[V]iew current [F]ile history' },
      { '<leader>rvR', '<cmd>DiffviewFileHistory<cr>', desc = 'Re[V]iew [R]epo history' },
      { '<leader>rvc', '<cmd>DiffviewClose<cr>', desc = 'Re[V]iew [C]lose' },

      { '<leader>grd', '<cmd>DiffviewOpen<cr>', desc = 'Diffview: open' },
      { '<leader>grD', '<cmd>DiffviewClose<cr>', desc = 'Diffview: close' },
      { '<leader>grh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Diffview: file history' },
      { '<leader>grH', '<cmd>DiffviewFileHistory<cr>', desc = 'Diffview: repo history' },
    },
  },
}
