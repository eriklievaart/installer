
syntax on

set nobackup
set noswapfile
set nowrap
set number

" copy and paste (shift+insert)
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" + to copy register 0 to clipboard
map + :let @+ = @0<CR>






