vim.pack.add({
  "https://github.com/FylerOrg/fyler.nvim",
})

require("fyler").setup({
  auto_confirm_simple_mutation = false,
  integrations = { icon = "nvim_web_devicons" },
  hooks = {
    on_rename = function(src_path, destination_path) Snacks.rename.on_rename_file(src_path, destination_path) end,
  },
  kind_presets = {
    split_left_most = {
      width = 30,
      win_opts = { winbar = "%{substitute(bufname('%'), '^fyler-[^:]*://', '', '')}" },
    },
  },
  use_as_default_explorer = true,
})

vim.keymap.set(
  "n",
  "<leader>e",
  function() require("fyler").toggle({ kind = "split_left_most" }) end,
  { desc = "Toggle file explorer" }
)
