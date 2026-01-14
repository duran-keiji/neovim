-- Git UX (GitLens / git graph-ish) for LazyVim
return {
  -- GitLens-like UI
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim", -- optional but highly recommended
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      integrations = {
        diffview = true,
        telescope = true,
      },
    },
  },

  -- Diffs, file history, PR-style review UI
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    opts = {},
  },

  -- Git graph viewer (commit graph + browse)
  {
    "rbong/vim-flog",
    cmd = { "Flog", "Flogsplit", "Floggit" },
    dependencies = {
      "tpope/vim-fugitive",
    },
  },
  { "tpope/vim-fugitive", cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "Gclog" } },
}

