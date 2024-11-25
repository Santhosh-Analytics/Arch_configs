" Basic Settings
"
set number
set relativenumber
set autoindent
set tabstop=4
set shiftwidth=4
set smarttab
set softtabstop=4
set mouse=a
set hlsearch
set encoding=UTF-8
set completeopt-=preview " For No Previews
set clipboard+=unnamedplus
set background=dark   
highlight Normal ctermbg=none 
highlight Normal guibg=none   
highlight NonText guibg=none   
highlight StatusLine guibg=none 
highlight VertSplit guibg=none highlight Normal ctermbg=none  

" Python Host Program Setup
let g:python3_host_prog = '~/miniconda3/bin/python3'

function! SetPythonHostProg()
    let l:python_path = system('which python3')
    let l:python_path = substitute(l:python_path, '\n', '', 'g')
    let l:python_path = substitute(l:python_path, '\r', '', 'g')

    if filereadable(l:python_path)
        let g:python3_host_prog = l:python_path
    else
        echom "Python 3 not found!"
    endif
endfunction

autocmd VimEnter * call SetPythonHostProg()
autocmd DirChanged * call SetPythonHostProg()

if exists('g:python3_host_prog')
    let g:UltiSnipsPythonPath = g:python3_host_prog
endif

" Conda Environment Setup
function! SwitchCondaEnv()
    " Check if Conda is activated
    let l:conda_env = $CONDA_DEFAULT_ENV
    if !empty(l:conda_env)
        " Set Python path based on active Conda environment
        let g:python3_host_prog = $CONDA_PREFIX . '/bin/python'
        echom "Using Python from Conda environment: " . l:conda_env
    else
        echom "No active Conda environment found. Using default Python."
        let g:python3_host_prog = '/home/san/miniconda3/bin/python3'
    endif
endfunction

augroup CondaEnv
    autocmd!
    autocmd BufEnter * call SwitchCondaEnv()
augroup END


" Set Coc Python Path Dynamically
function! SetCocPythonPath()
    let l:conda_env = $CONDA_DEFAULT_ENV
    if !empty(l:conda_env)
        let l:python_path = $CONDA_PREFIX . '/bin/python'
        call coc#config('python.pythonPath', l:python_path)
        echom "Setting Python path to: " . l:python_path
    else
        let l:default_python_path = '/usr/bin/python3'  " Change to your default Python path
        call coc#config('python.pythonPath', l:default_python_path)
        echom "No active Conda environment found. Using default Python: " . l:default_python_path
    endif
endfunction

augroup CocPythonPath
    autocmd!
    autocmd VimEnter * call SetCocPythonPath()
    autocmd DirChanged * call SetCocPythonPath()
augroup END

" Plugins
call plug#begin()

" Existing plugins
Plug 'http://github.com/tpope/vim-surround'
Plug 'https://github.com/preservim/nerdtree'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/lifepillar/pgsql.vim'
Plug 'https://github.com/ap/vim-css-color'
Plug 'https://github.com/rafi/awesome-vim-colorschemes'
Plug 'https://github.com/neoclide/coc.nvim', {'branch': 'release'}
Plug 'https://github.com/ryanoasis/vim-devicons'
Plug 'https://github.com/preservim/tagbar'
Plug 'https://github.com/terryma/vim-multiple-cursors'
Plug 'jiangmiao/auto-pairs'
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
Plug 'sheerun/vim-polyglot'
" Plug 'dense-analysis/ale'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'
" Plug 'psf/black', { 'do': 'npm install' }
" Plug 'tell-k/vim-autopep8'
Plug 'jupyter-vim/jupyter-vim'
Plug 'goerz/jupytext.vim'
Plug 'folke/which-key.nvim'

" New plugins
Plug 'neovim/nvim-lspconfig'
Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'hkupty/iron.nvim'
Plug 'vim-test/vim-test'
Plug 'glepnir/lspsaga.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'

call plug#end()


" LSP configuration for Ruff

" LSP configuration for Ruff
lua << EOF
require('lspconfig').ruff.setup{
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function() vim.lsp.buf.format() end
    })
  end,
}
EOF

autocmd BufWritePre *.py lua vim.lsp.buf.format()



" Color Scheme
colorscheme molokai

" Plugin Configurations
" NERDTree
let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"

" Airline
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" Coc
"inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"
" Which-key
lua << EOF
require("which-key").setup {
  timeout = true,
  timeoutlen = 500,
}
EOF

" LSP Configuration
" 
lua << EOF
local lspconfig = require('lspconfig')
lspconfig.pyright.setup{}
EOF


lua << EOF
require'lspconfig'.pyright.setup{}
EOF

" Debugger Configuration
"
lua << EOF
require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
EOF

" REPL Configuration
"
let g:iron_repl_open_cmd = 'belowright split'

" File Explorer Configuration
"
lua << EOF
require('nvim-tree').setup{}
EOF

" Telescope Configuration
"
lua << EOF
require('telescope').setup{}
EOF

" Git Integration Configuration
"
lua << EOF
require('gitsigns').setup{}
EOF

" Testing Configuration
let test#strategy = 'neovim'

" Key Mappings
nnoremap <C-f> :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-l> :call CocActionAsync('jumpDefinition')<CR>
nmap <F8> :TagbarToggle<CR>




let g:UltiSnipsExpandTrigger = '<C-e>'
let g:UltiSnipsJumpForwardTrigger = '<C-n>'
let g:UltiSnipsJumpBackwardTrigger = '<C-p>'


lua << EOF
local cmp = require'cmp'

cmp.setup({
  mapping = {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()  -- Insert a tab character if nothing is visible
      end
    end, { 'i', 's' }),  -- Works in insert and select modes

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()  -- Insert a tab character if nothing is visible
      end
    end, { 'i', 's' }),

    ['<CR>'] = cmp.mapping.confirm({ select = true }),  -- Confirm selection

    ['<C-Space>'] = cmp.mapping.complete(),  -- Trigger completion
  },

  sources = {
    { name = 'nvim_lsp' },  -- LSP source
    { name = 'buffer' },    -- Buffer source
    { name = 'path' },      -- Path source
  },

  -- Additional options can be set here
})
EOF
            



" Add new key mappings for added functionalities
nnoremap <space>e :NvimTreeToggle<CR>
nnoremap <space>f :Telescope find_files<CR>
nnoremap <space>b :Telescope buffers<CR>
nnoremap <space>d :lua require('dap').continue()<CR>
nnoremap <space>t :TestNearest<CR>





" Notes
" :PlugClean :PlugInstall :UpdateRemotePlugins
" :CocInstall coc-python
" :CocInstall coc-clangd
" :CocInstall coc-snippets
" :CocCommand snippets.edit... FOR EACH FILE TYPE
"


let g:ale_linters = {'python': []}

