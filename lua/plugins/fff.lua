vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(event)
    if event.data.spec.name ~= "fff" then
      return
    end
    if event.data.kind ~= "install" and event.data.kind ~= "update" then
      return
    end

    if not event.data.active then
      vim.cmd.packadd("fff")
    end
    require("fff.download").download_or_build_binary()
  end,
})

vim.pack.add({
  "https://github.com/dmtrKovalenko/fff",
})

local download = require("fff.download")
if not vim.uv.fs_stat(download.get_binary_path()) then
  download.download_or_build_binary()
end

require("fff").setup({ lazy_sync = true })

vim.keymap.set("n", "<leader><space>", function() require("fff").find_files() end, { desc = "Find files" })
vim.keymap.set(
  "n",
  "<leader>fc",
  function() require("fff").find_files_in_dir(vim.fn.stdpath("config")) end,
  { desc = "Find config files" }
)
vim.keymap.set("n", "<leader>/", function() require("fff").live_grep() end, { desc = "Live grep" })
vim.keymap.set(
  { "n", "x" },
  "<leader>sw",
  function() require("fff").live_grep_under_cursor() end,
  { desc = "Grep word or selection" }
)
vim.keymap.set("n", "<leader>sR", function() require("fff").resume() end, { desc = "Resume search" })
