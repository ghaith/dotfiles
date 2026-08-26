return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      open_mapping = nil,
      direction = 'float',
      shade_terminals = false,
      float_opts = {
        border = 'curved',
        width = function()
          return math.floor(vim.o.columns * 0.8)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.8)
        end,
      },
    },
    config = function(_, opts)
      require('toggleterm').setup(opts)

      local tmux = require 'ghaith.tmux'
      local Terminal = require('toggleterm.terminal').Terminal
      local scratch = Terminal:new {
        hidden = true,
        close_on_exit = false,
        direction = 'float',
        float_opts = opts.float_opts,
      }

      local toggle_scratch = function()
        if vim.env.TMUX and vim.fn.executable('tmux') == 1 then
          tmux.open_popup()
          return
        end
        scratch:toggle()
      end

      vim.keymap.set('n', '<leader>ww', tmux.focus_work_window, { desc = 'Focus tmux [W]ork window' })
      vim.keymap.set('n', '<leader>wv', function()
        tmux.open_editor_in_current_window('vertical')
      end, { desc = 'Open tmux [V]ertical editor split' })
      vim.keymap.set('n', '<leader>wh', function()
        tmux.open_editor_in_current_window('horizontal')
      end, { desc = 'Open tmux [H]orizontal editor split' })
      vim.keymap.set('n', '<leader>wc', tmux.prompt_and_run_in_work_window, { desc = 'Run command in tmux work window' })
      vim.keymap.set('n', '<leader>wC', tmux.prompt_and_run_in_current_context, { desc = 'Run command in current tmux context' })
      vim.keymap.set('n', '<leader>wz', toggle_scratch, { desc = 'Toggle centered scratch terminal' })
    end,
  },
}
