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
      -- レンダリングモード: "always" | "sync" | "async"
      render = "always",
      -- 見出しのスタイル設定（すべての見出しをレンダリング）
      headings = {
        "1", -- H1: 最大サイズ、太字
        "2", -- H2: 大サイズ、太字
        "3", -- H3: 中サイズ、太字
        "4", -- H4: 小サイズ、太字
        "5", -- H5: より小さいサイズ
        "6", -- H6: 最小サイズ
      },
      -- コードブロックの設定
      code_blocks = {
        highlight = true, -- シンタックスハイライト
        line_number = true, -- 行番号表示
      },
      -- より見やすいレンダリング設定
      filetypes = { "markdown" },
    },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown buf_toggle<cr>", desc = "Markdown: Render (toggle)" },
    },
  },
}

