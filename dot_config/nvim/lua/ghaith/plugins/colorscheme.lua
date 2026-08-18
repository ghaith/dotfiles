return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- catppuccin is truecolor-only (it force-enables termguicolors), so only
      -- load it when the terminal can take it; otherwise keep nvim's default
      -- scheme, which renders fine on 16/256 colors.
      local function apply()
        vim.cmd.colorscheme 'catppuccin-mocha'
      end
      if vim.g.has_truecolor then
        apply()
      else
        -- No tmux/COLORTERM guarantee: nvim's TUI still probes the terminal
        -- after startup and sets 'termguicolors' if it detects RGB support —
        -- apply the theme at that moment.
        vim.api.nvim_create_autocmd('OptionSet', {
          pattern = 'termguicolors',
          once = true,
          callback = function()
            if vim.o.termguicolors then
              apply()
            end
          end,
        })
      end

      -- You can configure highlights by doing something like:
      -- vim.cmd.hi 'Comment gui=none'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
