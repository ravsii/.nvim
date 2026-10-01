vim.pack.add({
  "https://github.com/gbprod/yanky.nvim",
})

require("yanky").setup({ highlight = { timer = 150 } })

vim.keymap.set({ "n", "x" }, "<leader>p", function() vim.cmd("YankyRingHistory") end, { desc = "Open Yank History" })

for _, key in ipairs({
  { "y", "<Plug>(YankyYank)", "Yank Text", { "n", "x" } },
  { "p", "<Plug>(YankyPutAfter)", "Put Text After Cursor", { "n", "x" } },
  { "P", "<Plug>(YankyPutBefore)", "Put Text Before Cursor", { "n", "x" } },
  { "[y", "<Plug>(YankyCycleForward)", "Cycle Forward Through Yank History" },
  { "]y", "<Plug>(YankyCycleBackward)", "Cycle Backward Through Yank History" },
}) do
  vim.keymap.set(key[4] or "n", key[1], key[2], { desc = key[3], remap = true })
end
