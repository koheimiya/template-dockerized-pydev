"" Plug manager ---- begin
call plug#begin('~/.local/share/nvim/plugged')
" basic ---
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-sensible'
Plug 'Townk/vim-autoclose'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
" git ---
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" GUIs ---
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tomasr/molokai'
" Language server
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
call plug#end()
"" Plug manager ---- end

" if (executable('pyls'))
"     let s:pyls_config = {'pyls': {'plugins': {
"         \   'pycodestyle': {'enabled': v:true},
"         \   'pydocstyle': {'enabled': v:false},
"         \   'pylint': {'enabled': v:false},
"         \   'flake8': {'enabled': v:true},
"         \   'jedi_definition': {
"         \     'follow_imports': v:true,
"         \     'follow_builtin_imports': v:true,
"         \   },
"         \ }}}
"     " pylsの起動定義
"     augroup LspPython
"         autocmd!
"         autocmd User lsp_setup call lsp#register_server({
"             \ 'name': 'pyls',
"             \ 'cmd': { server_info -> ['python', '-m', 'pyls'] },
"             \ 'whitelist': ['python'],
"             \ 'workspace_config': s:pyls_config
"             \})
"     augroup END
" endif

"" Keybindings ---- begin
nmap K :LspHover<CR>
nmap gd :LspDefinition<CR>
"" Keybindings ---- end

"" Fugitive ---- begin
nmap [figitive] <Nop>
map <Leader>g [figitive]
nmap <silent> [figitive]s :<C-u>Gstatus<CR>
nmap <silent> [figitive]d :<C-u>Gdiff<CR>
nmap <silent> [figitive]b :<C-u>Gblame<CR>
nmap <silent> [figitive]l :<C-u>Glog<CR>
"" Fugitive ---- end

"" QuickFix ---- begin
augroup quickfix_config
    au!
    au QuickFixCmdPost *grep* cwindow  " open quickFix on (vim)grep
augroup END
" adjust height
au FileType qf call AdjustWindowHeight(1, 3)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction
"" QuickFix ---- end

" override the defaults for a particular FileType
autocmd FileType rust
            \ let b:AutoClosePairs = AutoClose#ParsePairs("() [] {} ` \" '")

"" nerdtree ---- begin
" Auto open when specifying directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
"" nerdtree ---- end

"" Airline ---- begin
let g:airline#extensions#tabline#enabled = 1
"" Airline ---- end

"" Default ---- begin
set hidden
set tabstop=8
set autoindent
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4 

set shiftround          " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set infercase           " 補完時に大文字小文字を区別しない
set virtualedit=block     " カーソルを文字が存在しない部分でも動けるようにする
set hidden              " バッファを閉じる代わりに隠す（Undo履歴を残すため）
set showmatch           " 対応する括弧などをハイライト表示する
set matchtime=3         " 対応括弧のハイライト表示を3秒にする


set number
set ruler
set laststatus=2
set scrolloff=5
set nocursorline
set lazyredraw

nnoremap j gj
nnoremap k gk
noremap <C-c> <esc>
tnoremap <silent> <C-[> <C-\><C-n>
let mapleader = "\<Space>"

syntax enable
try
    colorscheme molokai
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme zellner
endtry
" set termguicolors
set background=dark
" set background=light
set t_Co=256
filetype indent plugin on

"" Default ---- end
