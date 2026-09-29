-- vim.pack
vim.keymap.set("n", "<leader>Pu", function() vim.pack.update() end, { desc = "Update plugins" })
vim.keymap.set("n", "<leader>Pl", function()
  vim.print(
    vim
      .iter(vim.pack.get(nil, { info = false }))
      :filter(function(plugin) return plugin.active end)
      :map(function(plugin) return plugin.spec.name end)
      :totable()
  )
end, { desc = "List plugins" })
