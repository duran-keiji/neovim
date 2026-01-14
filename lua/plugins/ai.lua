-- AI-driven development setup for LazyVim
-- - Inline completion: GitHub Copilot (via nvim-cmp)
-- - Chat / actions / inline edits: CodeCompanion (OpenAI / Anthropic / Ollama)

return {
  -- GitHub Copilot (auth: :Copilot auth)
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = function()
      local function node_major_version(node)
        local out = vim.fn.systemlist({ node, "-v" })[1] or ""
        return tonumber(out:match("v(%d+)")) or 0
      end

      local function pick_node()
        -- Best effort: pick the newest Node.js in PATH / common brew locations.
        local candidates = {}
        local exepath = vim.fn.exepath("node")
        if exepath ~= "" then
          table.insert(candidates, exepath)
        end
        vim.list_extend(candidates, {
          "/opt/homebrew/bin/node",
          "/usr/local/bin/node",
        })

        local best, best_v = "node", 0
        for _, node in ipairs(candidates) do
          if node and node ~= "" and vim.fn.executable(node) == 1 then
            local v = node_major_version(node)
            if v > best_v then
              best, best_v = node, v
            end
          end
        end
        return best
      end

      return {
        -- Copilot currently requires Node.js 22+
        copilot_node_command = pick_node(),
        suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<C-l>",
          accept_word = "<C-j>",
          accept_line = "<C-k>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = true },
      }
    end,
  },

  -- CodeCompanion (AI chat + actions + inline assistant)
  {
    "olimorris/codecompanion.nvim",
    version = "^18.0.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "MunifTanjim/nui.nvim",
    },
    opts = function()
      local function pick_adapter()
        -- Prefer cloud if keys exist, otherwise use local Ollama.
        if os.getenv("ANTHROPIC_API_KEY") and os.getenv("ANTHROPIC_API_KEY") ~= "" then
          return { name = "anthropic", model = os.getenv("ANTHROPIC_MODEL") or "claude-3-5-sonnet-latest" }
        end
        if os.getenv("OPENAI_API_KEY") and os.getenv("OPENAI_API_KEY") ~= "" then
          return { name = "openai", model = os.getenv("OPENAI_MODEL") or "gpt-4o-mini" }
        end
        return { name = "ollama", model = os.getenv("OLLAMA_MODEL") or "qwen2.5-coder:7b" }
      end

      local adapter = pick_adapter()

      return {
        adapters = {
          http = {
            -- Keep API keys out of config files.
            openai = function()
              return require("codecompanion.adapters").extend("openai", {
                env = { api_key = "OPENAI_API_KEY" },
              })
            end,
            anthropic = function()
              return require("codecompanion.adapters").extend("anthropic", {
                env = { api_key = "ANTHROPIC_API_KEY" },
              })
            end,
            ollama = function()
              return require("codecompanion.adapters").extend("ollama", {
                env = {
                  url = os.getenv("OLLAMA_HOST") or "http://127.0.0.1:11434",
                },
              })
            end,
          },
        },
        interactions = {
          chat = {
            adapter = adapter,
            tools = {
              opts = {
                -- Best-practice for AI dev: allow the agent to read/search/edit,
                -- but keep approvals on (defaults) to avoid surprises.
                default_tools = { "full_stack_dev" },
              },
            },
          },
          inline = {
            adapter = adapter,
          },
          cmd = {
            adapter = adapter,
          },
        },
        opts = {
          language = "Japanese",
        },
      }
    end,
  },
}

