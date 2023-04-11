-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

require('packer').startup(
    function(use)
        use 'wbthomason/packer.nvim'
        use {'projekt0n/github-nvim-theme', tag = 'v0.0.7'}

        -- General
        use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
        use {'nvim-treesitter/playground'}
        use {
            'neovim/nvim-lspconfig',
            config = function()
            end
        }
        use {'neoclide/coc.nvim', branch = 'release'}
        use {'nvim-tree/nvim-web-devicons'}
        use {'ryanoasis/vim-devicons'}

        -- Tabs
        use {'romgrk/barbar.nvim', requires = 'nvim-web-devicons'}

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
vim.g.mapleader = ' '

-- Treesitter
require('nvim-treesitter.configs').setup {
    ensure_installed = {'go', 'svelte'},
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true
    }
}
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

-- Telescope
local telescopeBuiltIn = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', telescopeBuiltIn.find_files, {})
vim.keymap.set('n', '<leader>pg', telescopeBuiltIn.live_grep, {})
vim.keymap.set('n', '<leader>pb', telescopeBuiltIn.buffers, {})
vim.keymap.set('n', '<leader>ph', telescopeBuiltIn.help_tags, {})

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

-- NERDTree
vim.g.NERDTreeWinPos = 'right' -- Appear on right
vim.g.NERDTreeShowHidden = true
-- NERDTree startup
vim.cmd [[autocmd VimEnter * NERDTree | wincmd p]]
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
            Type = {fg = c.syntax.func} -- type XXX is function color, it's the same as "type" by default (like in VSCode theme)
        }
    end
}

-- Auto formatting
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- Tabs
require 'barbar'.setup {
    animation = true,
    auto_hide = false,
    clickable = true,
    focus_on_close = 'right'
}

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

-- Keybinds
local noremap = {noremap = true}

-- Update config
map('n', [[<C-\>]], '<cmd>echo $MYVIMRC<CR><cmd>PackerSync<CR>', noremap)

-- Some common mappings
map('n', '<C-s>', ':w', noremap)
map('t', '<C-c>', '<C-c>', noremap) -- Interrupt (looks weird i know)

-- Nerd Tree
map('n', '<C-;>', ':NERDTreeFocus<CR>', noremap)
map('n', '<C-t>', ':NERDTreeToggle<CR>', noremap)
map('n', '<C-f>', ':NERDTreeFind<CR>', noremap)

-- Tabs
local tabsOpts = {noremap = true, silent = true}
map('n', '<Alt-,>', '<Cmd>BufferPrevious<CR>', tabsOpts)
map('n', '<Alt-.>', '<Cmd>BufferNext<CR>', tabsOpts)
map('n', '<C-w>', '<Cmd>BufferClose<CR>', tabsOpts)
-- Re-order to previous/next
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', tabsOpts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', tabsOpts)
-- map('n', '<A-p>', '<Cmd>BufferPin<CR>', tabsOpts)
map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', tabsOpts)
map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', tabsOpts)
map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', tabsOpts)
map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', tabsOpts)

-- Coc
local keyset = vim.keymap.set
-- Autocomplete
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset('i', '<TAB>', 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset('i', '<S-TAB>', [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
keyset('i', '<cr>', [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
keyset('i', '<c-j>', '<Plug>(coc-snippets-expand-jump)')
keyset('i', '<c-space>', 'coc#refresh()', {silent = true, expr = true})
keyset('n', '[g', '<Plug>(coc-diagnostic-prev)', {silent = true})
keyset('n', ']g', '<Plug>(coc-diagnostic-next)', {silent = true})

-- GoTo code navigation
keyset('n', 'gd', '<Plug>(coc-definition)', {silent = true})
keyset('n', 'gy', '<Plug>(coc-type-definition)', {silent = true})
keyset('n', 'gi', '<Plug>(coc-implementation)', {silent = true})
keyset('n', 'gr', '<Plug>(coc-references)', {silent = true})

-- Use K to show documentation in preview window
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
keyset('n', 'gh', '<CMD>lua _G.show_docs()<CR>', {silent = true})

-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup('CocGroup', {})
vim.api.nvim_create_autocmd(
    'CursorHold',
    {
        group = 'CocGroup',
        command = "silent call CocActionAsync('highlight')",
        desc = 'Highlight symbol under cursor on CursorHold'
    }
)

-- Symbol renaming
keyset('n', '<leader>rn', '<Plug>(coc-rename)', {silent = true})

-- Formatting selected code
keyset('x', '<leader>f', '<Plug>(coc-format-selected)', {silent = true})
keyset('n', '<leader>f', '<Plug>(coc-format-selected)', {silent = true})

-- Setup formatexpr specified filetype(s)
vim.api.nvim_create_autocmd(
    'FileType',
    {
        group = 'CocGroup',
        pattern = 'typescript,json',
        command = "setl formatexpr=CocAction('formatSelected')",
        desc = 'Setup formatexpr specified filetype(s).'
    }
)

-- Update signature help on jump placeholder
vim.api.nvim_create_autocmd(
    'User',
    {
        group = 'CocGroup',
        pattern = 'CocJumpPlaceholder',
        command = "call CocActionAsync('showSignatureHelp')",
        desc = 'Update signature help on jump placeholder'
    }
)

-- Apply codeAction to the selected region
-- Example: `<leader>aap` for current paragraph
local opts = {silent = true, nowait = true}
keyset('x', '<leader>a', '<Plug>(coc-codeaction-selected)', opts)
keyset('n', '<leader>a', '<Plug>(coc-codeaction-selected)', opts)

-- Remap keys for apply code actions at the cursor position.
keyset('n', '<leader>ac', '<Plug>(coc-codeaction-cursor)', opts)
-- Remap keys for apply code actions affect whole buffer.
keyset('n', '<leader>as', '<Plug>(coc-codeaction-source)', opts)
-- Remap keys for applying codeActions to the current buffer
keyset('n', '<leader>ac', '<Plug>(coc-codeaction)', opts)
-- Apply the most preferred quickfix action on the current line.
keyset('n', '<leader>qf', '<Plug>(coc-fix-current)', opts)

-- Remap keys for apply refactor code actions.
keyset('n', '<leader>re', '<Plug>(coc-codeaction-refactor)', {silent = true})
keyset('x', '<leader>r', '<Plug>(coc-codeaction-refactor-selected)', {silent = true})
keyset('n', '<leader>r', '<Plug>(coc-codeaction-refactor-selected)', {silent = true})

-- Run the Code Lens actions on the current line
keyset('n', '<leader>cl', '<Plug>(coc-codelens-action)', opts)

-- Map function and class text objects
-- NOTE: Requires 'textDocument.documentSymbol' support from the language server
keyset('x', 'if', '<Plug>(coc-funcobj-i)', opts)
keyset('o', 'if', '<Plug>(coc-funcobj-i)', opts)
keyset('x', 'af', '<Plug>(coc-funcobj-a)', opts)
keyset('o', 'af', '<Plug>(coc-funcobj-a)', opts)
keyset('x', 'ic', '<Plug>(coc-classobj-i)', opts)
keyset('o', 'ic', '<Plug>(coc-classobj-i)', opts)
keyset('x', 'ac', '<Plug>(coc-classobj-a)', opts)
keyset('o', 'ac', '<Plug>(coc-classobj-a)', opts)

-- Remap <C-f> and <C-b> to scroll float windows/popups
---@diagnostic disable-next-line: redefined-local
local opts = {silent = true, nowait = true, expr = true}
keyset('n', '<C-f>', 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keyset('n', '<C-b>', 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
keyset('i', '<C-f>', 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
keyset('i', '<C-b>', 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
keyset('v', '<C-f>', 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keyset('v', '<C-b>', 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)

-- Add `:Format` command to format current buffer
vim.api.nvim_create_user_command('Format', "call CocAction('format')", {})

-- " Add `:Fold` command to fold current buffer
vim.api.nvim_create_user_command('Fold', "call CocAction('fold', <f-args>)", {nargs = '?'})

-- Add `:OR` command for organize imports of the current buffer
vim.api.nvim_create_user_command('OR', "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

-- Add (Neo)Vim's native statusline support
-- NOTE: Please see `:h coc-status` for integrations with external plugins that
-- provide custom statusline: lightline.vim, vim-airline
vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

-- Mappings for CoCList
-- code actions and coc stuff
---@diagnostic disable-next-line: redefined-local
local opts = {silent = true, nowait = true}
-- Show all diagnostics
keyset('n', '<space>a', ':<C-u>CocList diagnostics<cr>', opts)
-- Manage extensions
keyset('n', '<space>e', ':<C-u>CocList extensions<cr>', opts)
-- Show commands
keyset('n', '<space>c', ':<C-u>CocList commands<cr>', opts)
-- Find symbol of current document
keyset('n', '<space>o', ':<C-u>CocList outline<cr>', opts)
-- Search workspace symbols
keyset('n', '<space>s', ':<C-u>CocList -I symbols<cr>', opts)
-- Do default action for next item
keyset('n', '<space>j', ':<C-u>CocNext<cr>', opts)
-- Do default action for previous item
keyset('n', '<space>k', ':<C-u>CocPrev<cr>', opts)
-- Resume latest coc list
keyset('n', '<space>p', ':<C-u>CocListResume<cr>', opts)
