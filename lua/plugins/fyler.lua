require("plugins.icons")

vim.pack.add({
  "https://github.com/FylerOrg/fyler.nvim",
}, { confirm = false, load = true })

require("fyler").setup({
  auto_confirm_simple_mutation = false,
  integrations = { icon = "mini_icons" },
  kind_presets = {
    split_left_most = {
      width = 30,
      win_opts = { winbar = "%{substitute(bufname('%'), '^fyler-[^:]*://', '', '')}" },
    },
  },
  use_as_default_explorer = true,
})

vim.keymap.set("n", "<leader>e", function()
  require("fyler").toggle({ kind = "split_left_most" })
end, { desc = "Toggle file explorer" })
