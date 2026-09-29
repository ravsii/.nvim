local parsers = { "lua", "luadoc", "vim", "vimdoc", "go", "gomod", "gowork", "gosum", "markdown", "slint" }

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(event)
    local name = event.data.spec.name
    local kind = event.data.kind
    if kind ~= "install" and kind ~= "update" then return end

    local target = ({ ["tree-sitter-d2"] = "nvim-install", ["tree-sitter-ghostty"] = "nvim_install" })[name]
    if target then
      local result = vim.system({ "make", target }, { cwd = event.data.path }):wait()
      if result.code ~= 0 then
        vim.notify(name .. " build failed:\n" .. (result.stderr or ""), vim.log.levels.ERROR)
      end
    elseif name == "nvim-treesitter" then
      vim.schedule(function() vim.cmd.TSUpdate() end)
    end
  end,
})

vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/ravsii/tree-sitter-d2",
  "https://github.com/bezhermoso/tree-sitter-ghostty",
}, { confirm = false, load = true })

local treesitter = require("nvim-treesitter")
treesitter.setup()
treesitter.install(parsers)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function(event)
    if vim.treesitter.get_parser(event.buf, nil, { error = false }) then
      vim.treesitter.start(event.buf)
    end
  end,
})

require("nvim-treesitter-textobjects").setup({ move = { set_jumps = true } })
require("treesitter-context").setup({
  enable = true,
  multiwindow = true,
  max_lines = 3,
  line_numbers = true,
  multiline_threshold = 20,
  trim_scope = "outer",
  mode = "topline",
})

local map = vim.keymap.set

map("x", "[n", function() require("vim.treesitter._select").select_prev(vim.v.count1) end, { desc = "Select previous treesitter node" })
map("x", "]n", function() require("vim.treesitter._select").select_next(vim.v.count1) end, { desc = "Select next treesitter node" })

map({ "n", "x", "o" }, "<C-Space>", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_parent(vim.v.count1)
  else
    vim.lsp.buf.selection_range(vim.v.count1)
  end
end, { desc = "Select parent treesitter node or outer LSP selection" })

map({ "n", "x", "o" }, "<BS>", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_child(vim.v.count1)
  else
    vim.lsp.buf.selection_range(-vim.v.count1)
  end
end, { desc = "Select child treesitter node or inner LSP selection" })

map("n", "<M-h>", function() require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner") end, { desc = "Swap previous parameter" })
map({ "n", "x", "o" }, "<M-l>", function() require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner") end, { desc = "Swap next parameter" })

for _, binding in ipairs({
  { "]f", "@function.outer", "next", "goto_next_start" },
  { "[f", "@function.outer", "previous", "goto_previous_start" },
  { "]a", "@parameter.outer", "next", "goto_next_start" },
  { "[a", "@parameter.outer", "previous", "goto_previous_start" },
  { "]c", "@class.outer", "next", "goto_next_start" },
  { "[c", "@class.outer", "previous", "goto_previous_start" },
}) do
  local key, capture, direction, method = unpack(binding)
  map({ "n", "x", "o" }, key, function()
    require("nvim-treesitter-textobjects.move")[method](capture)
  end, { desc = direction .. " " .. capture })
end
