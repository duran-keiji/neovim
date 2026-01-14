-- Hacker-ish UI for LazyVim (green-based / "Matrix-ish"):
-- - Dark background
-- - Green accents (and optionally green-ish text)
-- - Terminal-like chrome (minimal icons, simple separators)
return {
  -- Colorscheme: gruvbox as the base, then push towards green-on-black
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      contrast = "hard",
      transparent_mode = false,
      bold = true,
      italic = {
        strings = false,
        comments = true,
        operators = false,
        folds = true,
      },
    },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.cmd.colorscheme("gruvbox")

      local function apply_terminal_chrome()
        local green = "#00ff5f"
        local dark_green = "#004d1a"
        local near_black = "#050806"
        local float_black = "#070b08"
        local normal_default = vim.api.nvim_get_hl(0, { name = "Normal", link = false }) or {}
        local normalnc_default = vim.api.nvim_get_hl(0, { name = "NormalNC", link = false }) or {}

        -- File text colors: keep gruvbox defaults (colorful syntax)
        -- UI: keep darker bg + green accents
        vim.api.nvim_set_hl(0, "Normal", { fg = normal_default.fg, bg = near_black })
        vim.api.nvim_set_hl(0, "NormalNC", { fg = normalnc_default.fg or normal_default.fg, bg = near_black })
        vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = near_black, bg = near_black })
        vim.api.nvim_set_hl(0, "NonText", { fg = dark_green })
        vim.api.nvim_set_hl(0, "Whitespace", { fg = dark_green })

        -- Line numbers / separators / columns
        vim.api.nvim_set_hl(0, "LineNr", { fg = dark_green })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = green, bold = true })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = near_black })
        vim.api.nvim_set_hl(0, "FoldColumn", { fg = dark_green, bg = near_black })
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = dark_green, bg = near_black })
        vim.api.nvim_set_hl(0, "VertSplit", { fg = dark_green, bg = near_black })
        vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#0b120e" })

        -- Cursorline
        vim.api.nvim_set_hl(0, "CursorLine", { bg = "#0b120e" })

        -- Popups / menus
        vim.api.nvim_set_hl(0, "NormalFloat", { fg = normal_default.fg, bg = float_black })
        vim.api.nvim_set_hl(0, "FloatBorder", { fg = dark_green, bg = float_black })
        vim.api.nvim_set_hl(0, "Pmenu", { fg = normal_default.fg, bg = float_black })
        vim.api.nvim_set_hl(0, "PmenuSel", { fg = near_black, bg = green, bold = true })

        -- Search / selection
        vim.api.nvim_set_hl(0, "Visual", { bg = "#123a20" })
        vim.api.nvim_set_hl(0, "Search", { fg = near_black, bg = green, bold = true })
        vim.api.nvim_set_hl(0, "IncSearch", { fg = near_black, bg = "#b8ff00", bold = true })

        -- Diagnostics: simple underlines (avoid wavy undercurl)
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = false, underline = true })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = false, underline = true })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = false, underline = true })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = false, underline = true })

        -- Statusline fallback groups
        vim.api.nvim_set_hl(0, "StatusLine", { fg = green, bg = near_black })
        vim.api.nvim_set_hl(0, "StatusLineNC", { fg = dark_green, bg = near_black })
      end

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "gruvbox",
        callback = apply_terminal_chrome,
      })

      apply_terminal_chrome()
    end,
  },

  -- Tell LazyVim to use it
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },

  -- Statusline theme + separators
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.options = opts.options or {}
      opts.options.theme = "gruvbox"
      -- Terminal-like: no fancy powerline glyphs, no icons
      opts.options.icons_enabled = false
      opts.options.section_separators = { left = "", right = "" }
      opts.options.component_separators = { left = "|", right = "|" }
      return opts
    end,
  },

  -- Tabs/bufferline separators
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.options = opts.options or {}
      -- Terminal-like: reduce chrome/icons
      opts.options.separator_style = "thin"
      opts.options.show_buffer_icons = false
      opts.options.show_buffer_close_icons = false
      opts.options.show_close_icon = false
      opts.options.indicator = { style = "none" }
      opts.options.diagnostics = false
      return opts
    end,
  },
}

