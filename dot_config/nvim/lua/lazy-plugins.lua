-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --

  -- modular approach: using `require 'path/name'` will
  -- include a plugin definition from file lua/path/name.lua

  require 'ghaith.plugins.gitsigns',
  require 'ghaith.plugins.which-key',
  require 'ghaith.plugins.telescope',
  require 'ghaith.plugins.trouble',
  require 'ghaith.plugins.lspconfig',
  require 'ghaith.plugins.conform',
  require 'ghaith.plugins.cmp',
  require 'ghaith.plugins.colorscheme',
  require 'ghaith.plugins.todo-comments',
  require 'ghaith.plugins.mini',
  require 'ghaith.plugins.treesitter',
  require 'ghaith.plugins.debug',
  require 'ghaith.plugins.indent_line',
  require 'ghaith.plugins.lint',
  require 'ghaith.plugins.autopairs',
  require 'ghaith.plugins.neo-tree',
  require 'ghaith.plugins.rust',
  require 'ghaith.plugins.testing',
  require 'ghaith.plugins.colorizer-config',
  require 'ghaith.plugins.line',
  require 'ghaith.plugins.remote-nvim',
  require 'ghaith.plugins.copilot',
  require 'ghaith.plugins.codecompanion',
  require 'ghaith.plugins.terminal',
  require 'ghaith.plugins.chezmoi',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- { import = 'custom.plugins' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
