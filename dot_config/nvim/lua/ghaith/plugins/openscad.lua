return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'openscad' })
      end
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    ft = 'openscad',
  },
  {
    'MunifTanjim/nui.nvim', -- dependency for nvim-colorizer
  },
  {
    'NvChad/nvim-colorizer.lua',
    event = 'BufReadPost',
    ft = { 'openscad' },
    opts = { 'rgb', 'names', 'hex' },
  },
  {
    -- Live preview for OpenSCAD via DBus
    'nvim-neo-tree/neo-tree.nvim', -- A dummy plugin to attach the config to
    config = function()
      vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = '*.scad',
        callback = function()
          local current_file = vim.fn.expand('%:p')
          local dbus_cmd = string.format(
            'dbus-send --session --print-reply --dest=org.openscad.OpenSCAD /org/openscad/OpenSCAD org.openscad.OpenSCAD.reloadFile string:%s',
            current_file
          )
          vim.fn.system(dbus_cmd)
          vim.notify('OpenSCAD reloaded: ' .. current_file, vim.log.levels.INFO, { title = 'OpenSCAD Live Preview' })
        end,
        desc = 'Reload OpenSCAD file on save via DBus',
      })
    end,
  },
}