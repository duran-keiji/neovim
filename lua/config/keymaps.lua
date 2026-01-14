-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- AI (CodeCompanion)
vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "AI: Actions" })
vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI: Chat (toggle)" })

-- AI (prompt library aliases)
vim.keymap.set("n", "<leader>am", "<cmd>CodeCompanion /commit<cr>", { desc = "AI: Commit message" })
vim.keymap.set("v", "<leader>ae", ":<C-u>'<,'>CodeCompanion /explain<cr>", { desc = "AI: Explain selection" })
vim.keymap.set("v", "<leader>af", ":<C-u>'<,'>CodeCompanion /fix<cr>", { desc = "AI: Fix selection" })
vim.keymap.set("v", "<leader>at", ":<C-u>'<,'>CodeCompanion /tests<cr>", { desc = "AI: Tests for selection" })

-- AI (Copilot)
vim.keymap.set("n", "<leader>aP", "<cmd>Copilot panel<cr>", { desc = "AI: Copilot Panel" })

-- Neo-tree
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Explorer (neo-tree)" })

-- Which-key (fallback)
vim.keymap.set("n", "<leader><leader>", "<cmd>WhichKey <leader><cr>", { desc = "WhichKey: Leader mappings" })

-- Git (Neogit / Diffview / Flog)
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Git: Neogit" })
vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewOpen<cr>", { desc = "Git: Diffview (open)" })
vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Git: Diffview (close)" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "Git: File history" })
vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "Git: Repo history" })
vim.keymap.set("n", "<leader>gl", "<cmd>Flog -graph -all<cr>", { desc = "Git: Graph (Flog)" })
vim.keymap.set("n", "<leader>gL", "<cmd>Flog -graph -all<cr>", { desc = "Git: Graph (all branches)" })
vim.keymap.set("n", "<leader>gG", "<cmd>Git log --graph --oneline --all --decorate<cr>", { desc = "Git: Graph (fugitive)" })
vim.keymap.set("n", "<leader>gv", "<cmd>Git log --graph --pretty=format:'%C(yellow)%h%C(reset) - %C(bold green)(%ar)%C(reset) %s %C(bold blue)<%an>%C(reset)' --abbrev-commit --all --decorate<cr>", { desc = "Git: Graph (verbose)" })
vim.keymap.set("n", "<leader>gt", function()
  vim.cmd("new")
  vim.cmd("setlocal buftype=nofile")
  vim.cmd("setlocal filetype=git")
  vim.fn.termopen("git log --graph --oneline --all --decorate")
end, { desc = "Git: Graph (terminal)" })
vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Git: Blame line (toggle)" })
