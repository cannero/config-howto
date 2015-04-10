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


