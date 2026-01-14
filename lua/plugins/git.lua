-- Git UX (GitLens / git graph-ish) for LazyVim
return {
  -- GitLens-like UI
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      integrations = {
        diffview = true,
        telescope = true,
      },
      graph_style = "unicode",
      disable_commit_confirmation = false,
      use_per_project_settings = true,
      commit_editor = {
        kind = "auto",
      },
      log_view = {
        kind = "tab",
      },
      status = {
        recent_commit_count = 10,
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
    init = function()
      vim.g.flog_default_opts = {
        all = true,
        graph = true,
        date = "short",
        max_count = 1000,
      }
      -- Flogがgit logを呼び出す際に確実に--graphオプションを渡す
      vim.g.flog_graph_args = "--graph"
    end,
    config = function()
      -- Flog起動時に確実にグラフ表示を有効化
      vim.api.nvim_create_user_command("FlogGraph", function()
        vim.cmd("Flog -graph -all")
      end, { desc = "Flog with graph view" })
    end,
  },
  { "tpope/vim-fugitive", cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "Gclog" } },
}

