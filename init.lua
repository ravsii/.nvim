-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]


require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	
	-- Github theme
	use({'projekt0n/github-nvim-theme', tag = 'v0.0.7',
		config = function()
			require('github-theme').setup({
				comment_style = 'altfont',
				theme_style = 'dark',
				function_style = 'nocombine',
				keyword_style = 'nocombine',
			})
		end
	})
	
	-- General
	use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = { "go", "svelte" },
				sync_install = false,
				auto_install = true,
				-- ignore_install = { "javascript" },
				highlight = {
					enable = true,
					
					-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
					-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
					-- the name of the parser)
					disable = { "c", "rust" },
					
					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
			})
		end
	}

	use {'neovim/nvim-lspconfig',
		config = function()
			lspconfig = require "lspconfig"
			util = require "lspconfig/util"

			lspconfig.gopls.setup {
				cmd = {"gopls", "serve"},
				filetypes = {"go", "gomod"},
				on_attach = function(client, bufnr)
					vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc");
				end,
				root_dir = util.root_pattern("go.work", "go.mod", ".git"),
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
					},
				},
			}
		end
	}

	use {'neoclide/coc.nvim', branch = 'release'}

	-- Tabs
	use {'romgrk/barbar.nvim', requires = 'nvim-web-devicons'}

	-- NERDTree
	use 'nvim-tree/nvim-web-devicons'
	use 'preservim/nerdtree'

	-- Status bar
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true }
	}
end)

-- General
vim.opt.number = true
vim.opt.relativenumber = true

-- NERDTree
vim.g.NERDTreeWinPos = "right" -- Appear on right
vim.cmd [[autocmd VimEnter * NERDTree]] -- Run at startup

-- Auto formatting
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- Tabs
vim.g.barbar_auto_setup = false -- disable auto-setup
require'barbar'.setup {
  animation = true,
  auto_hide = false,
  tabpages = true,
  clickable = true,
  focus_on_close = 'right',
  -- Hide inactive buffers and file extensions. Other options are `alternate`, `current`, and `visible`.
  hide = {extensions = true, inactive = true},
  -- Sets the maximum padding width with which to surround each tab
  maximum_padding = 1,

  -- Sets the minimum padding width with which to surround each tab
  minimum_padding = 1,

  -- Sets the maximum buffer name length.
  maximum_length = 30,

  -- If set, the letters for each buffer in buffer-pick mode will be
  -- assigned based on their name. Otherwise or in case all letters are
  -- already assigned, the behavior is to assign letters in order of
  -- usability (see order below)
  semantic_letters = true,
}

-- Status bar
require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'palenight',
  }
})


-- Keybinds



local map = vim.api.nvim_set_keymap 
local opts = { noremap = true, silent = true }
local noremap = { noremap = true }
vim.g.mapleader = ' '

-- Update config
map('n', [[<C-\>]], "<cmd>echo $MYVIMRC<CR><cmd>PackerSync<CR>", noremap)

map('n', '<C-s>', ":w", opts)

-- Nerd Tree
map('n', '<leader>n', ':NERDTreeFocus<CR>', noremap)
map('n', '<C-n>', ':NERDTree<CR>', noremap)
map('n', '<C-t>', ':NERDTreeToggle<CR>', noremap)
map('n', '<C-f>', ':NERDTreeFind<CR>', noremap)

-- Tabs

-- Move to previous/next
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
-- Re-order to previous/next
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
-- Goto buffer in position...
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
-- Pin/unpin buffer
map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
-- Close buffer
map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Magic buffer-picking mode
map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
-- Sort automatically by...
map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used