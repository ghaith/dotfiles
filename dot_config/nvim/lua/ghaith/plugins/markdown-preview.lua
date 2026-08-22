return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown", "vimwiki" },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  keys = {
    {
      "<leader>mp",
      "<cmd>MarkdownPreviewToggle<cr>",
      desc = "Toggle [M]arkdown [P]review",
      ft = { "markdown", "vimwiki" },
    },
  },
  init = function()
    vim.g.mkdp_filetypes = { "markdown", "vimwiki" }
  end,
}
