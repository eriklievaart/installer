
syntax on

set nobackup
set noswapfile
set nowrap
set number
set splitbelow
set splitright


" copy and paste (shift+insert)
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" + to copy register 0 to clipboard
nmap + :let @+ = @0<CR>
" ctrl-n to toggle line numbers
nmap <C-N> :set invnumber<CR>

" delete first character on line and move down
nmap <F2> @='^xj'<CR>
" comment line with '#' and move down
nmap <F3> @='I#<C-V><Esc>j'<CR>

" on F5 store last executed command in register 'r'
map <F5> :let @r = @:<CR>
map! <F5> <ESC>:let @r = @:<CR>
" on F6 execute the command stored in register 'r'
map <F6> :@r<CR>
map! <F6> <ESC>:@r<CR>
" on F8 clear console and run current file
map <F8> :w <bar> !clear; ./% <CR>
map! <F8> <ESC>:w <bar> !clear; ./% <CR>

" ctrl-alt arrow to move line
nnoremap <C-A-Up> :m .-2<CR>==
nnoremap <C-A-Down> :m .+1<CR>==
inoremap <C-A-Up> <Esc>:m .-2<CR>==gi
inoremap <C-A-Down> <Esc>:m .+1<CR>==gi


