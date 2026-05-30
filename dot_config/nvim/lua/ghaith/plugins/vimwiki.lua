return {
  'vimwiki/vimwiki',
  ft = { 'markdown', 'vimwiki' },
  init = function()
    vim.g.vimwiki_list = {
      {
        path = vim.fn.expand '~/wiki/',
        syntax = 'markdown',
        ext = '.md',
      },
    }
    vim.g.vimwiki_global_ext = 0
  end,
}
