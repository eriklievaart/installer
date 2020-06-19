
execute pathogen#infect()

let NERDTreeQuitOnOpen=1

let g:airline#extensions#tabline#enabled = 1
let g:airline_statusline_ontop=0
let g:airline_theme='powerlineish'

syntax on

" don't highlight matching parenthesis
let loaded_matchparen = 0

set nobackup
set noswapfile
set nowrap
set number
set hlsearch
set incsearch
set splitbelow
set splitright
set showcmd


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

map <F9> :NERDTreeToggle <CR>
map! <F9> <ESC>:NERDTreeToggle <CR>

" ctrl-alt arrow to move line
nnoremap <C-A-Up> :m .-2<CR>==
nnoremap <C-A-Down> :m .+1<CR>==
inoremap <C-A-Up> <Esc>:m .-2<CR>==gi
inoremap <C-A-Down> <Esc>:m .+1<CR>==gi

nnoremap ;1 :b 1<CR>
nnoremap ;2 :b 2<CR>
nnoremap ;3 :b 3<CR>
nnoremap ;4 :b 4<CR>
nnoremap ;5 :b 5<CR>
nnoremap ;6 :b 6<CR>
nnoremap ;7 :b 7<CR>
nnoremap ;8 :b 8<CR>
nnoremap ;9 :b 9<CR>
nnoremap ;0 :b 0<CR>
nnoremap ;] :bn<CR>
nnoremap ;[ :bp<CR>

nnoremap ;a :quit!<CR>
nnoremap ;q :quit<CR>
nnoremap ;w :w<CR>
nnoremap ;x :x<CR>













