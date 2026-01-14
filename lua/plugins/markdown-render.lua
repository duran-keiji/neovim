-- Render Markdown inside Neovim (no browser)
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- keep defaults; customize later if needed
    },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown buf_toggle<cr>", desc = "Markdown: Render (toggle)" },
    },
  },
}

