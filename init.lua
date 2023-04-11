-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

require('packer').startup(
    function(use)
        use 'wbthomason/packer.nvim'
        use {'projekt0n/github-nvim-theme', tag = 'v0.0.7'}

        -- General
        use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
        use {'nvim-treesitter/playground'}
        use {'neovim/nvim-lspconfig'}
        use {'neoclide/coc.nvim', branch = 'release'}
        use {'nvim-tree/nvim-web-devicons'}
        use {'ryanoasis/vim-devicons'}

        -- NERDTree
        use 'preservim/nerdtree'

        -- Status bar
        use {'nvim-lualine/lualine.nvim', requires = {'nvim-tree/nvim-web-devicons', opt = true}}

        -- Git
        use {'airblade/vim-gitgutter'}

        -- ToggleTerm
        use {'akinsho/toggleterm.nvim', tag = '*'}

        -- Telescope
        use {'nvim-telescope/telescope.nvim', tag = '0.1.1', requires = {{'nvim-lua/plenary.nvim'}}}

        -- Comments
        use {'terrortylor/nvim-comment'}

        -- Scrollbar
        use {'petertriho/nvim-scrollbar'}
    end
)

-- Helper funcs
local map = vim.api.nvim_set_keymap

-- General
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.updatetime = 100
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.signcolumn = 'yes'
vim.g.mapleader = '^['

-- Update config
map('n', [[<C-\>]], '<cmd>PackerSync<CR>', {noremap = true})

-- Some common mappings
map('n', '<C-s>', ':w<CR>', {noremap = true})
map('t', '<C-c>', '<C-c>', {noremap = true}) -- Interrupt (looks weird i know)
map('n', '<M-z>', [[:set wrap!<CR>]], {noremap = true}) -- Toggle line wrap

-- Splits
map('n', '<M-h>', [[<Cmd>wincmd h<CR>]], {noremap = true})
map('n', '<M-j>', [[<Cmd>wincmd j<CR>]], {noremap = true})
map('n', '<M-k>', [[<Cmd>wincmd k<CR>]], {noremap = true})
map('n', '<M-l>', [[<Cmd>wincmd l<CR>]], {noremap = true})
map('n', '<M-o>', ':vsplit', {noremap = true})

-- Treesitter
require('nvim-treesitter.configs').setup {
    ensure_installed = {'go', 'svelte', 'javascript', 'typescript'},
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true
    }
}

-- Telescope
require('telescope').setup {
    defaults = {
        file_ignore_patterns = {'builds/.*', 'node_modules/.*', 'dist/.*'},
        layout_strategy = 'flex'
    }
}
local telescopeBuiltIn = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', telescopeBuiltIn.find_files, {})
vim.keymap.set('n', '<M-p>g', telescopeBuiltIn.live_grep, {})
vim.keymap.set('n', '<M-p>b', telescopeBuiltIn.buffers, {})
vim.keymap.set('n', '<M-p>h', telescopeBuiltIn.help_tags, {})

-- LSP
require('lspconfig').gopls.setup {
    cmd = {'gopls', 'serve'},
    filetypes = {'go', 'gomod'},
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    end,
    root_dir = require('lspconfig/util').root_pattern('go.work', 'go.mod', '.git'),
    settings = {
        gopls = {
            analyses = {
                unusedparams = true
            },
            staticcheck = true
        }
    }
}
require('lspconfig').svelte.setup {}

-- NERDTree
vim.g.NERDTreeWinPos = 'right' -- Appear on right
vim.g.NERDTreeShowHidden = true
map('n', '<C-;>', ':NERDTreeFocus<CR>', {noremap = true})
map('n', [[<C-'>;]], ':NERDTreeToggle<CR>', {noremap = true})
map('n', [[<C-'>f]], ':NERDTreeFind<CR>', {noremap = true})
-- NERDTree startup
-- vim.cmd [[autocmd VimEnter * NERDTree | wincmd p]]
-- NERDTree close
vim.cmd [[autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif]]
vim.cmd [[autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif]]

-- Github Theme
require('github-theme').setup {
    comment_style = 'none',
    dark_float = true,
    function_style = 'none',
    keyword_style = 'none',
    variable_style = 'none',
    overrides = function(c)
        return {
            -- type XXX interface/struct, XXX is a function color(red) the same as "type" by default. We change it to func color (purple) like in VSCode theme
            Type = {fg = c.syntax.func}
        }
    end
}

-- Scrollbar
require('scrollbar').setup()

-- Comments
require('nvim_comment').setup()
map('v', '<C-/>', ':CommentToggle<CR>', {silent = true, noremap = true})

-- Auto formatting
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- Status bar
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'palenight'
    }
}

-- ToggleTerm
require('toggleterm').setup {
    open_mapping = [[<C-`>]]
}

-- Coc
local keyset = vim.keymap.set
-- Autocomplete
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
map('i', '<TAB>', 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
map('i', '<S-TAB>', [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
map('i', '<cr>', [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
map('i', '<c-space>', 'coc#refresh()', {silent = true, expr = true})
map('n', '[g', '<Plug>(coc-diagnostic-prev)', {silent = true})
map('n', ']g', '<Plug>(coc-diagnostic-next)', {silent = true})

-- GoTo code navigation
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
map('n', 'gd', '<Plug>(coc-definition)', {silent = true})
map('n', 'gy', '<Plug>(coc-type-definition)', {silent = true})
map('n', 'gi', '<Plug>(coc-implementation)', {silent = true})
map('n', 'gr', '<Plug>(coc-references)', {silent = true})
map('n', 'gh', '<CMD>lua _G.show_docs()<CR>', {silent = true})

-- Treesitter Playground
-- require 'nvim-treesitter.configs'.setup {
--     playground = {
--         enable = true,
--         disable = {},
--         updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
--         persist_queries = false, -- Whether the query persists across vim sessions
--         keybindings = {
--             toggle_query_editor = 'o',
--             toggle_hl_groups = 'i',
--             toggle_injected_languages = 't',
--             toggle_anonymous_nodes = 'a',
--             toggle_language_display = 'I',
--             focus_language = 'f',
--             unfocus_language = 'F',
--             update = 'R',
--             goto_node = '<cr>',
--             show_help = '?'
--         }
--     }
-- }
