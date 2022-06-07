set number
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set mouse=a 
syntax on
filetype on
filetype plugin on
filetype indent on


"Paste ident
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ""
endfunction
