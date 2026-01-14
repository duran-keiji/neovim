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

-- Markdown: より見やすい表示設定
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "markdown_inline" },
  callback = function(args)
    -- Spell undercurl often shows as red wavy underline
    vim.opt_local.spell = false

    -- LSP/diagnostics underline can also show as wavy underline
    pcall(vim.diagnostic.config, { underline = false }, args.buf)

    -- Markdown表示の改善
    vim.opt_local.wrap = true -- 自動折り返し
    vim.opt_local.linebreak = true -- 単語境界で折り返し
    vim.opt_local.conceallevel = 2 -- マークダウン記法を一部隠す（見出しの#など）
    vim.opt_local.concealcursor = "" -- カーソル行でも隠す
    vim.opt_local.foldmethod = "expr" -- 折りたたみ方法
    vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()" -- Treesitterで折りたたみ
    vim.opt_local.number = true -- 行番号表示
    vim.opt_local.relativenumber = true -- 相対行番号

    -- 見出しの強調表示（背景色を薄く設定）
    -- 注意: 背景色が非常に薄いため、見た目ではほとんど分からない場合があります
    local heading_bg_h1 = "#030603"  -- 非常に薄い背景（H1）
    local heading_bg_h2 = "#040604"  -- 非常に薄い背景（H2）
    
    vim.api.nvim_set_hl(0, "markdownH1", {
      fg = "#00ff88", -- より明るい緑
      bg = heading_bg_h1,
      bold = true,
      underline = false,
    })
    vim.api.nvim_set_hl(0, "@markdown.heading.1.markdown", {
      fg = "#00ff88",
      bg = heading_bg_h1,
      bold = true,
    })
    vim.api.nvim_set_hl(0, "markdownH2", {
      fg = "#00e673", -- 明るい緑
      bg = heading_bg_h2,
      bold = true,
    })
    vim.api.nvim_set_hl(0, "@markdown.heading.2.markdown", {
      fg = "#00e673",
      bg = heading_bg_h2,
      bold = true,
    })
    
    -- Treesitterのハイライトが適用された後に再設定（複数回試行）
    local function apply_heading_colors()
      vim.api.nvim_set_hl(args.buf, "@markdown.heading.1.markdown", {
        fg = "#00ff88",
        bg = heading_bg_h1,
        bold = true,
      })
      vim.api.nvim_set_hl(args.buf, "@markdown.heading.2.markdown", {
        fg = "#00e673",
        bg = heading_bg_h2,
        bold = true,
      })
      -- グローバルにも設定
      vim.api.nvim_set_hl(0, "@markdown.heading.1.markdown", {
        fg = "#00ff88",
        bg = heading_bg_h1,
        bold = true,
      })
      vim.api.nvim_set_hl(0, "@markdown.heading.2.markdown", {
        fg = "#00e673",
        bg = heading_bg_h2,
        bold = true,
      })
    end
    
    -- 即座に適用
    apply_heading_colors()
    
    -- Treesitterのハイライトが適用された後に再適用
    vim.schedule(function()
      apply_heading_colors()
      -- さらに少し待ってから再適用（Treesitterが完全に読み込まれるまで）
      vim.defer_fn(apply_heading_colors, 100)
      vim.defer_fn(apply_heading_colors, 500)  -- さらに待ってから再適用
    end)
    vim.api.nvim_set_hl(0, "markdownH3", {
      fg = "#66ffaa", -- 明るいシアン緑
      bold = true,
    })
    vim.api.nvim_set_hl(0, "@markdown.heading.3.markdown", {
      fg = "#66ffaa",
      bold = true,
    })
    vim.api.nvim_set_hl(0, "markdownH4", {
      fg = "#88ffbb", -- 薄い緑
      bold = true,
    })
    vim.api.nvim_set_hl(0, "@markdown.heading.4.markdown", {
      fg = "#88ffbb",
      bold = true,
    })
    vim.api.nvim_set_hl(0, "markdownH5", {
      fg = "#aaffcc", -- さらに薄い緑
      bold = true,
    })
    vim.api.nvim_set_hl(0, "markdownH6", {
      fg = "#bbffdd", -- 最も薄い緑
      bold = true,
    })

    -- コードブロックの強調（より読みやすく）
    vim.api.nvim_set_hl(0, "markdownCodeBlock", {
      bg = "#0f1a15", -- より明るい背景
      fg = "#e0e8f0", -- より明るいテキスト
      bold = false,
    })
    vim.api.nvim_set_hl(0, "@markdown.code_block.markdown", {
      bg = "#0f1a15",
      fg = "#e0e8f0",
    })
    -- インラインコード（より目立つように）
    vim.api.nvim_set_hl(0, "markdownCode", {
      bg = "#1a2a1f", -- より明るい背景
      fg = "#00ffd5", -- 明るいシアン
      bold = false,
    })
    vim.api.nvim_set_hl(0, "@markdown.inline_code.markdown", {
      bg = "#1a2a1f",
      fg = "#00ffd5",
    })

    -- リンクの強調（より目立つように）
    vim.api.nvim_set_hl(0, "markdownLinkText", {
      fg = "#00ccff", -- より明るい青
      bg = "#0d1a2a", -- より濃い背景
      underline = true,
      bold = true, -- 太字でより目立つ
    })
    vim.api.nvim_set_hl(0, "@markdown.link_text.markdown", {
      fg = "#00ccff",
      bg = "#0d1a2a",
      underline = true,
      bold = true,
    })
    vim.api.nvim_set_hl(0, "markdownUrl", {
      fg = "#66ddff", -- より明るい青
      underline = true,
      italic = true,
    })
    vim.api.nvim_set_hl(0, "@markdown.link_url.markdown", {
      fg = "#66ddff",
      underline = true,
      italic = true,
    })

    -- リストの強調（より見やすく）
    vim.api.nvim_set_hl(0, "markdownListMarker", {
      fg = "#00ff88", -- より明るい緑
      bold = true,
    })
    vim.api.nvim_set_hl(0, "@markdown.list_marker.markdown", {
      fg = "#00ff88",
      bold = true,
    })
    -- チェックボックス
    vim.api.nvim_set_hl(0, "@markdown.list_marker_checkbox.checked.markdown", {
      fg = "#00ff88", -- チェック済みは明るい緑
      bold = true,
    })
    vim.api.nvim_set_hl(0, "@markdown.list_marker_checkbox.unchecked.markdown", {
      fg = "#66ffaa", -- 未チェックは薄い緑
      bold = true,
    })

    -- 引用ブロックの強調（より見やすく）
    vim.api.nvim_set_hl(0, "markdownBlockquote", {
      fg = "#88ffbb", -- より明るい緑
      bg = "#0f1f0f", -- より濃い背景
      italic = true,
    })
    vim.api.nvim_set_hl(0, "@markdown.block_quote.markdown", {
      fg = "#88ffbb",
      bg = "#0f1f0f",
      italic = true,
    })
    vim.api.nvim_set_hl(0, "@markdown.block_quote_delimiter.markdown", {
      fg = "#00ff88", -- より明るい緑
      bold = true,
    })

    -- 強調テキスト（より目立つように）
    vim.api.nvim_set_hl(0, "markdownBold", {
      fg = "#ffffff", -- 白で最大のコントラスト
      bold = true,
    })
    vim.api.nvim_set_hl(0, "@markdown.strong.markdown", {
      fg = "#ffffff",
      bold = true,
    })
    vim.api.nvim_set_hl(0, "markdownItalic", {
      fg = "#ccffee", -- より明るい緑白
      italic = true,
    })
    vim.api.nvim_set_hl(0, "@markdown.emphasis.markdown", {
      fg = "#ccffee",
      italic = true,
    })

    -- 水平線のスタイル（より目立つように）
    vim.api.nvim_set_hl(0, "markdownRule", {
      fg = "#00ff88", -- より明るい緑
      bold = true,
    })
    vim.api.nvim_set_hl(0, "@markdown.thematic_break.markdown", {
      fg = "#00ff88",
      bold = true,
    })

    -- テーブルのスタイル（より見やすく）
    vim.api.nvim_set_hl(0, "@markdown.table_delimiter.markdown", {
      fg = "#00ff88", -- より明るい緑
      bold = true,
    })
    vim.api.nvim_set_hl(0, "@markdown.table_cell.markdown", {
      fg = "#ccffee", -- より明るいテキスト
    })

    -- 数式のスタイル（より見やすく）
    vim.api.nvim_set_hl(0, "@markdown.math.markdown", {
      fg = "#00ffff", -- より明るいシアン
      italic = true,
      bold = false,
    })

    -- 通常テキストのコントラスト向上
    vim.api.nvim_set_hl(0, "@markdown.literal.markdown", {
      fg = "#e0e8f0", -- より明るいテキスト
    })
    -- 段落テキストの可読性向上
    vim.api.nvim_set_hl(0, "@markdown.paragraph.markdown", {
      fg = "#d0e0d8", -- より明るいグレーグリーン
    })

    -- 見出しの前後に視覚的な区切りを追加（カスタムハイライト）
    -- H1の下に線を引くような視覚効果
    vim.api.nvim_set_hl(0, "MarkdownH1Separator", {
      fg = "#00ff5f",
      bg = "#0a1f0a",
    })
    vim.api.nvim_set_hl(0, "MarkdownH2Separator", {
      fg = "#00c850",
      bg = "#0b1a12",
    })

    -- 段落間の視覚的な区別
    vim.api.nvim_set_hl(0, "@markdown.paragraph.markdown", {
      fg = "#d0d7de",
    })

    -- 強調マーカーのスタイル（より見やすく）
    vim.api.nvim_set_hl(0, "@markdown.strong_delimiter.markdown", {
      fg = "#00ff88", -- より明るい緑
      bold = true,
    })
    vim.api.nvim_set_hl(0, "@markdown.emphasis_delimiter.markdown", {
      fg = "#88ffbb", -- より明るい緑
      italic = true,
    })

    -- コードブロックのデリミター（より見やすく）
    vim.api.nvim_set_hl(0, "@markdown.code_fence_content.markdown", {
      bg = "#0f1a15", -- より明るい背景
      fg = "#e0e8f0", -- より明るいテキスト
    })
    vim.api.nvim_set_hl(0, "@markdown.code_fence_delimiter.markdown", {
      fg = "#00ff88", -- より明るい緑
      bold = true,
    })

    -- より良いコントラストのための背景色調整
    -- 見出し行の背景を少し暗くして視認性向上
    vim.api.nvim_set_hl(0, "CursorLine", {
      bg = "#0b120e",
    })
  end,
})

-- Markdown: 見出しの視覚的な区別を強化（Syntax highlightの後で実行）
vim.api.nvim_create_autocmd({ "Syntax", "ColorScheme", "BufEnter", "BufWinEnter", "FileType" }, {
  pattern = { "*.md", "*.markdown" },
  callback = function(args)
    local buf = args.buf or vim.api.nvim_get_current_buf()
    
    -- Treesitterのハイライトが適用された後に実行
    local function apply_heading_hl()
      -- 見出しの背景色を再設定（さらに薄い背景）
      local heading_bg_h1 = "#030603"  -- 非常に薄い背景（H1）
      local heading_bg_h2 = "#040604"  -- 非常に薄い背景（H2）
      
      vim.api.nvim_set_hl(buf, "@markdown.heading.1.markdown", {
        fg = "#00ff88", -- より明るい緑
        bg = heading_bg_h1,
        bold = true,
      })
      vim.api.nvim_set_hl(buf, "@markdown.heading.2.markdown", {
        fg = "#00e673", -- より明るい緑
        bg = heading_bg_h2,
        bold = true,
      })
      vim.api.nvim_set_hl(buf, "@markdown.heading.3.markdown", {
        fg = "#66ffaa", -- より明るいシアン緑
        bold = true,
      })
      -- グローバルにも設定（念のため）
      vim.api.nvim_set_hl(0, "@markdown.heading.1.markdown", {
        fg = "#00ff88",
        bg = heading_bg_h1,
        bold = true,
      })
      vim.api.nvim_set_hl(0, "@markdown.heading.2.markdown", {
        fg = "#00e673",
        bg = heading_bg_h2,
        bold = true,
      })
    end
    
    -- 即座に適用
    apply_heading_hl()
    
    -- スケジュールで再適用
    vim.schedule(function()
      apply_heading_hl()
      -- さらに少し待ってから再適用
      vim.defer_fn(apply_heading_hl, 100)
      vim.defer_fn(apply_heading_hl, 300)
    end)
  end,
})

-- Markdown見出しの背景色を確認・調整するためのデバッグコマンドを読み込み
pcall(require, "config.markdown-debug")
