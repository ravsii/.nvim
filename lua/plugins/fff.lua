vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(event)
    if event.data.spec.name ~= "fff" then return end
    if event.data.kind ~= "install" and event.data.kind ~= "update" then return end

    if not event.data.active then vim.cmd.packadd("fff") end
    require("fff.download").download_or_build_binary()
  end,
})

vim.pack.add({
  { src = "https://github.com/dmtrKovalenko/fff", version = vim.version.range("*") },
}, { confirm = false, load = true })

local download = require("fff.download")
if not vim.uv.fs_stat(download.get_binary_path()) then download.download_or_build_binary() end

require("fff").setup({ lazy_sync = true })

local map = vim.keymap.set

map("n", "<leader><space>", function() require("fff").find_files() end, { desc = "Find files" })
map("n", "<leader>fc", function()
  require("fff").find_files_in_dir(vim.fn.stdpath("config"))
end, { desc = "Find config files" })
map("n", "<leader>/", function() require("fff").live_grep() end, { desc = "Live grep" })
map({ "n", "x" }, "<leader>sw", function()
  require("fff").live_grep_under_cursor()
end, { desc = "Grep word or selection" })
map("n", "<leader>sR", function() require("fff").resume() end, { desc = "Resume search" })
