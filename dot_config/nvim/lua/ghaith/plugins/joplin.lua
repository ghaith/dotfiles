return {
  {
    'happyeric77/joplin.nvim',
    cmd = {
      'JoplinTree',
      'JoplinFind',
      'JoplinSearch',
      'JoplinFindNotebook',
      'JoplinBrowse',
      'JoplinPing',
      'JoplinHelp',
    },
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
    },
    opts = {
      token_env = 'JOPLIN_TOKEN',
      tree = {
        height = 12,
        position = 'botright',
        focus_after_open = false,
        auto_sync = true,
      },
      keymaps = {
        search = '<leader>js',
        search_notebook = '<leader>jS',
        toggle_tree = '<leader>jt',
      },
      startup = {
        validate_on_load = true,
        show_warnings = true,
        async_validation = true,
        validation_delay = 100,
      },
    },
    config = function(_, opts)
      require('joplin').setup(opts)
    end,
  },
}
