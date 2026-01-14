-- Make which-key show immediately when pressing <leader> (Space)
return {
  {
    "folke/which-key.nvim",
    -- Ensure it's loaded & initialized early enough for <leader> usage.
    event = "VimEnter",
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      -- Ensure group names are registered even if opts merging changes.
      wk.add({
        { "<leader>a", group = "AI" },
        { "<leader>g", group = "Git" },
        { "<leader>m", group = "Markdown" },
      })
    end,
    opts = function(_, opts)
      opts = opts or {}

      -- Give readable names to groups (instead of "+ N keymaps")
      opts.spec = opts.spec or {}
      table.insert(opts.spec, { "<leader>a", group = "AI" })
      table.insert(opts.spec, { "<leader>g", group = "Git" })
      table.insert(opts.spec, { "<leader>m", group = "Markdown" })

      -- IMPORTANT:
      -- Auto triggers are not created for existing keymaps.
      -- Many setups map <Space> to <Nop>, so <leader> won't trigger which-key unless we add it.
      opts.triggers = {
        { "<leader>", mode = { "n", "v" } },
      }

      -- Default behavior is to delay for non-plugin triggers.
      -- We keep that to avoid noisy popups for "g", "z", etc,
      -- but show instantly for <leader> (= Space in LazyVim).
      opts.delay = function(ctx)
        local keys = ctx and ctx.keys or ""
        if keys == "<leader>" or keys == "<Space>" or keys == " " then
          return 0
        end
        return ctx.plugin and 0 or 200
      end

      return opts
    end,
  },
}

