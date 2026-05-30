return {
  {
    'rcarriga/nvim-notify',
    event = 'VimEnter',
    opts = {
      render = 'wrapped-compact',
      stages = 'fade_in_slide_out',
      timeout = 2500,
      top_down = true,
      background_colour = '#000000',
    },
    config = function(_, opts)
      local notify = require 'notify'
      notify.setup(opts)
      vim.notify = notify
    end,
  },
}
