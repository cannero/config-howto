set nocompatible
syntax on
set guifont=Source_Code_Pro:h11:cANSI
set autochdir
set ruler showcmd showmode
:cabbrev q <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'close' : 'q')<CR>
set expandtab
set shiftwidth=2
set softtabstop=2
set autoindent
set backspace=2
set ignorecase

if has("gui_running")
  " GUI is running or is about to start.
  " Maximize gvim window (for an alternative on Windows, see simalt below).
  set lines=55 columns=100
endif
