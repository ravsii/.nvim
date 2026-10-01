vim.pack.add({
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/spacedentist/resolve.nvim",
})

require("gitsigns").setup({
  sign_column = true,
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    delay = 0,
  },
  max_file_length = 10000,
})

local conflict_keys = {
  { "]x", "<cmd>ResolveNext<cr>", "Next conflict" },
  { "[x", "<cmd>ResolvePrev<cr>", "Previous conflict" },
  { "<leader>gco", "<cmd>ResolveOurs<cr>", "Choose ours" },
  { "<leader>gct", "<cmd>ResolveTheirs<cr>", "Choose theirs" },
  { "<leader>gcb", "<cmd>ResolveBoth<cr>", "Choose both" },
  { "<leader>gcB", "<cmd>ResolveBothReverse<cr>", "Choose both (reverse)" },
  { "<leader>gcm", "<cmd>ResolveBase<cr>", "Choose base" },
  { "<leader>gcn", "<cmd>ResolveNone<cr>", "Choose none" },
  { "<leader>gcl", "<cmd>ResolveList<cr>", "List conflicts" },
  { "<leader>gcdo", "<cmd>ResolveDiffOurs<cr>", "Diff ours" },
  { "<leader>gcdt", "<cmd>ResolveDiffTheirs<cr>", "Diff theirs" },
  { "<leader>gcdb", "<cmd>ResolveDiffBoth<cr>", "Diff both" },
  { "<leader>gcdv", "<cmd>ResolveDiffOursTheirs<cr>", "Diff ours vs theirs" },
  { "<leader>gcdV", "<cmd>ResolveDiffTheirsOurs<cr>", "Diff theirs vs ours" },
}

require("resolve").setup({ default_keymaps = false })

require("which-key").add({
  { "<leader>gc", group = "Git Conflicts", mode = "n" },
  { "<leader>gcd", group = "Diff", mode = "n" },
})

for _, key in ipairs(conflict_keys) do
  vim.keymap.set("n", key[1], key[2], { desc = key[3] })
end
