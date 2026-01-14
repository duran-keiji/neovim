-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Refresh which-key after LazyVim finishes loading (VeryLazy),
-- so keys defined by plugins and late-loaded keymaps are visible.
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- Ensure user keymaps are loaded after LazyVim sets <leader>
    pcall(require, "config.keymaps")

    local ok, buf = pcall(require, "which-key.buf")
    if ok and buf and buf.clear then
      buf.clear()
    end
  end,
})

-- Markdown: disable red squiggles (spell + diagnostic underline) in markdown buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "markdown_inline" },
  callback = function(args)
    -- Spell undercurl often shows as red wavy underline
    vim.opt_local.spell = false

    -- LSP/diagnostics underline can also show as wavy underline
    pcall(vim.diagnostic.config, { underline = false }, args.buf)
  end,
})
