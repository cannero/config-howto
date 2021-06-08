set nocompatible
syntax on
set guifont=Source_Code_Pro:h11:cANSI
set autochdir
set ruler showcmd showmode
:cabbrev q <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'close' : 'q')<CR>
set expandtab
set shiftwidth=2
set softtabstop=2
" set autoindent
" for javascript
set cindent
set backspace=2
set ignorecase

"Get the 2-space YAML as the default when hit carriage return after the colon
"something like <filetype plugin indent on> has to be set for indentation
autocmd FileType yaml,yml setlocal ts=2 sts=2 sw=2 expandtab

if has("gui_running")
  " GUI is running or is about to start.
  " Maximize gvim window (for an alternative on Windows, see simalt below).
  set lines=45 columns=95
  set guicursor+=a:blinkon0
  " line numbers
  set nu
endif

noremap <silent> k gk
noremap <silent> j gj
" noremap <silent> 0 g0
" noremap <silent> $ g$

" remember buffer
set hidden
:hi Normal guibg=Grey95
