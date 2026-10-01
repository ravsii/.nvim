vim.opt.runtimepath:prepend(vim.fn.getcwd())

local function git(dir, ...)
  local result = vim.system({ "git", "-C", dir, ... }, { text = true }):wait()
  assert(result.code == 0, result.stderr)
  return vim.trim(result.stdout)
end

local function repo(path, branch)
  vim.fn.mkdir(path, "p")
  git(path, "init", "-b", branch)
  local file = path .. "/example.txt"
  vim.fn.writefile({ "initial" }, file)
  git(path, "add", "example.txt")
  git(path, "-c", "user.name=Test", "-c", "user.email=test@example.invalid", "commit", "-m", "initial")
  return file
end

local root = vim.fn.tempname()
local branch_repo = root .. "/branch"
local file = repo(branch_repo, "master")
local expected_base = git(branch_repo, "rev-parse", "HEAD")
git(branch_repo, "switch", "-c", "feature")
vim.fn.writefile({ "feature" }, file)
git(branch_repo, "add", "example.txt")
git(branch_repo, "-c", "user.name=Test", "-c", "user.email=test@example.invalid", "commit", "-m", "feature")
git(branch_repo, "switch", "master")
vim.fn.writefile({ "master advanced" }, file)
git(branch_repo, "add", "example.txt")
git(branch_repo, "-c", "user.name=Test", "-c", "user.email=test@example.invalid", "commit", "-m", "master advanced")
git(branch_repo, "switch", "feature")

local opts
local calls = {}
vim.pack.add = function(urls)
  assert(vim.deep_equal(urls, { "https://github.com/lewis6991/gitsigns.nvim" }))
end
package.preload.gitsigns = function()
  return {
    setup = function(config) opts = config end,
    change_base = function(base)
      calls[#calls + 1] = { base = base, bufnr = vim.api.nvim_get_current_buf() }
    end,
  }
end

require("plugins.git")
assert(type(opts.on_attach) == "function")
assert(opts.signcolumn == true and opts.signs_staged_enable == false)
local buf = vim.api.nvim_create_buf(true, false)
vim.api.nvim_buf_set_name(buf, file)
opts.on_attach(buf)
assert(vim.wait(3000, function() return #calls == 1 end), "merge-base was not selected")
assert(calls[1].base == expected_base, "base must be the branching point, not current master")
assert(calls[1].bufnr == buf, "base must apply to the attached buffer")

local main_file = repo(root .. "/main-only", "main")
local main_buf = vim.api.nvim_create_buf(true, false)
vim.api.nvim_buf_set_name(main_buf, main_file)
opts.on_attach(main_buf)
vim.wait(300, function() return false end)
assert(#calls == 1, "repositories without master must keep the default comparison")

vim.fn.delete(root, "rf")
print("Git signs merge-base and missing-master fallback OK (offline)")
