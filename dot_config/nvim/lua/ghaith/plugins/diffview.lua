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
    config = function(_, opts)
      require('diffview').setup(opts)

      local tmux = require 'ghaith.tmux'

      local function open_branch_review()
        local base = tmux.git_base_ref()
        vim.cmd('DiffviewOpen ' .. base .. '...HEAD')
      end

      local function open_last_review()
        vim.cmd 'DiffviewOpen HEAD~1..HEAD'
      end

      local function open_ref_review()
        tmux.pick_ref(function(ref)
          vim.cmd('DiffviewOpen ' .. ref .. '...HEAD')
        end)
      end

      vim.keymap.set('n', '<leader>rvb', open_branch_review, { desc = 'Re[V]iew [B]ranch vs base' })
      vim.keymap.set('n', '<leader>rvl', open_last_review, { desc = 'Re[V]iew [L]ast commit' })
      vim.keymap.set('n', '<leader>rvr', open_ref_review, { desc = 'Re[V]iew against [R]ef' })
      vim.keymap.set('n', '<leader>rvf', '<cmd>DiffviewFileHistory %<cr>', { desc = 'Re[V]iew current [F]ile history' })
      vim.keymap.set('n', '<leader>rvR', '<cmd>DiffviewFileHistory<cr>', { desc = 'Re[V]iew [R]epo history' })
      vim.keymap.set('n', '<leader>rvc', '<cmd>DiffviewClose<cr>', { desc = 'Re[V]iew [C]lose' })

      vim.keymap.set('n', '<leader>grd', '<cmd>DiffviewOpen<cr>', { desc = 'Diffview: open' })
      vim.keymap.set('n', '<leader>grD', '<cmd>DiffviewClose<cr>', { desc = 'Diffview: close' })
      vim.keymap.set('n', '<leader>grh', '<cmd>DiffviewFileHistory %<cr>', { desc = 'Diffview: file history' })
      vim.keymap.set('n', '<leader>grH', '<cmd>DiffviewFileHistory<cr>', { desc = 'Diffview: repo history' })
    end,
  },
}
