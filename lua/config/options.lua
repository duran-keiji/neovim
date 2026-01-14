-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Prefer Homebrew "node" (and other tools) over older versions in PATH.
-- This fixes plugins that shell out to `node` (e.g. markdown-preview.nvim).
do
  local path = vim.env.PATH or ""
  local prefer = { "/opt/homebrew/bin", "/usr/local/bin" }

  -- Remove any existing occurrences, then prepend in preferred order.
  local parts = vim.split(path, ":", { plain = true, trimempty = true })
  local filtered = {}
  local skip = {}
  for _, p in ipairs(prefer) do
    skip[p] = true
  end

  for _, p in ipairs(parts) do
    if not skip[p] then
      table.insert(filtered, p)
    end
  end

  local new_parts = {}
  for _, p in ipairs(prefer) do
    if vim.fn.isdirectory(p) == 1 then
      table.insert(new_parts, p)
    end
  end
  vim.list_extend(new_parts, filtered)

  vim.env.PATH = table.concat(new_parts, ":")
end

-- Ensure which-key is initialized by the time you start pressing <leader>.
-- (LazyVim may load it late; this makes it reliable.)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local ok, wk = pcall(require, "which-key")
    if ok and wk and wk.did_setup == false then
      wk.setup()
    end
  end,
})

-- Load custom keymaps early so they appear in which-key immediately
-- (LazyVim normally loads `config/keymaps.lua` on the VeryLazy event).
-- NOTE: Do not load keymaps here; ensure mapleader and plugins are initialized first.

-- "Hacker-ish" UI defaults (feel free to tweak)
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.fillchars:append({ eob = " " }) -- hide ~ at end of buffer
vim.opt.list = true
vim.opt.listchars = {
  tab = "»·",
  trail = "·",
  extends = "›",
  precedes = "‹",
  nbsp = "␣",
}
-- Terminal-like: avoid translucency/blur
vim.opt.pumblend = 0
vim.opt.winblend = 0

-- More "terminal/hacker" vibes
vim.opt.number = true
vim.opt.laststatus = 3 -- global statusline
vim.opt.showmode = false
vim.opt.cmdheight = 0 -- commandline only when needed (Neovim 0.9+)
vim.opt.signcolumn = "yes:1"
vim.opt.colorcolumn = "100"
vim.opt.guicursor =
  "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkon0" -- solid block in normal

-- More terminal-ish UI separators
vim.opt.fillchars = vim.opt.fillchars + {
  vert = "|",
  horiz = "-",
  horizup = "+",
  horizdown = "+",
  vertleft = "+",
  vertright = "+",
  verthoriz = "+",
}

-- Ensure UTF-8 encoding for proper Unicode display (including git graph lines)
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
