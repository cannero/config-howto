syntax enable
set autochdir
set expandtab
set hidden
set title
set mouse=a
set clipboard+=unnamedplus

"Get the 2-space YAML as the default when hit carriage return after the colon
"something like <filetype plugin indent on> has to be set for indentation
autocmd FileType yaml,yml setlocal ts=2 sts=2 sw=2 expandtab

noremap  <silent> k gk
noremap  <silent> j gj
" noremap  <silent> 0 g0
" noremap  <silent> $ g$