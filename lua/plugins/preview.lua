require("utils.pack_changed").on_change("markdown-preview.nvim", function()
  vim.cmd.packadd("markdown-preview.nvim")
  vim.fn["mkdp#util#install_sync"](true)
end)

require("utils.pack_changed").on_change("swagger-preview.nvim", function(data)
  local result = vim.system({ "npm", "install" }, { cwd = data.path }):wait()
  if result.code ~= 0 then
    vim.notify("swagger-preview.nvim npm install failed:\n" .. (result.stderr or ""), vim.log.levels.ERROR)
  end
end)

vim.pack.add({
  "https://github.com/iamcco/markdown-preview.nvim",
  "https://github.com/vinnymeller/swagger-preview.nvim",
})

require("swagger-preview").setup({
  port = 6969,
  host = "127.0.0.1",
})

-- Markdown Preview creates buffer-local commands on FileType/BufEnter.
vim.cmd("doautocmd FileType")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(event)
    vim.keymap.set("n", "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", {
      buffer = event.buf,
      desc = "Markdown Preview",
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "json",
  callback = function(event)
    vim.keymap.set("n", "<leader>cp", "<cmd>SwaggerPreviewToggle<cr>", {
      buffer = event.buf,
      desc = "Toggle Swagger Preview",
    })
  end,
})
