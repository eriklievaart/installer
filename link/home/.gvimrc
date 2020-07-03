
" hide toolbar
set guioptions-=T
colorscheme torte

set guifont=Inconsolata\ Semi-Condensed\ 13
function ChangeFontSize(delta) abort
    let l:repl = printf('\=eval(submatch(0)+%d)', a:delta)
    let &guifont = substitute(&guifont, '\d\+', l:repl, '')
	set columns=999
	set lines=999
endfunction

noremap ;- :call ChangeFontSize(-1)<CR>
noremap ;= :call ChangeFontSize(1)<CR>
noremap ;p :set guifont?<CR>

