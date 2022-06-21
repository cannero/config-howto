syntax enable
set autochdir
set expandtab
set hidden
set title
set mouse=a
set clipboard+=unnamedplus
set shiftwidth=2
set softtabstop=-1

"Get the 2-space YAML as the default when hit carriage return after the colon
"something like <filetype plugin indent on> has to be set for indentation
autocmd FileType yaml,yml setlocal ts=2 sts=2 sw=2 expandtab

noremap  <silent> k gk
noremap  <silent> j gj
" noremap  <silent> 0 g0
" noremap  <silent> $ g$

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

" packages
" kotlin-vim vim-airline vim-toml