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
call plug#end()
"" Plug manager ---- end

"" Deoplete ---- begin
let g:deoplete#enable_at_startup = 1
"" Deoplete ---- end

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

"" haskell-vim ---- begin
let g:haskell_indent_disable = 1
let g:haskell_classic_highlighting = 1  " haskell-vim
let g:haskell_enable_quantification = 1
let g:haskell_enable_recursivedo = 1
let g:haskell_enable_arrowsyntax = 1
let g:haskell_enable_pattern_synonyms = 1
let g:haskell_enable_typeroles = 1
let g:haskell_enable_static_pointers = 1
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
"" haskell-vim ---- end

""
" override the defaults for a particular FileType
autocmd FileType rust
            \ let b:AutoClosePairs = AutoClose#ParsePairs("() [] {} ` \" '")
""

"" nerdtree ---- begin
" Auto open when specifying directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
"" nerdtree ---- end

"" LanguageClinet ---- begin
set hidden
let g:LanguageClient_serverCommands = {
    \ 'haskell': ['hie', '--lsp'],
    \ 'python': ['pyls'],
    \ 'rust': ['rls'],
    \ }
let g:LanguageClient_autoStart = 1
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
"" LanguageClinet ---- end

"" Airline ---- begin
" let g:airline_theme='papercolor'
" let g:airline_theme='solarized'
let g:airline#extensions#tabline#enabled = 1
"" Airline ---- end

"" Default ---- begin
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
" colorscheme zellner
colorscheme molokai
" set termguicolors
set background=dark
" set background=light
set t_Co=256
filetype indent plugin on


"" Default ---- end
