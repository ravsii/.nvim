-- Бинд заработает после переноса DAP и его языковых адаптеров.
vim.keymap.set("n", "<leader>td", function()
  require("neotest").run.run({ strategy = "dap" })
end, { desc = "Debug Nearest" })
