
syntax on

set nobackup
set noswapfile
set nowrap
set number

" copy and paste (shift+insert)
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" + to copy register 0 to clipboard
nmap + :let @+ = @0<CR>
" ctrl-n to toggle line numbers
nmap <C-N> :set invnumber<CR>

" on F5 store last executed command in register 'r'
map <F5> :let @r = @:<CR>
" on F6 execute the command stored in register 'r'
map <F6> :@r<CR>



