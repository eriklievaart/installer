
colorscheme default

execute pathogen#infect()

let NERDTreeQuitOnOpen=1

let g:airline#extensions#tabline#enabled = 1
let g:airline_statusline_ontop=0
let g:airline_theme='powerlineish'

" use syntax highlighting on search
syntax on

" don't highlight matching parenthesis
let loaded_matchparen = 0

set noautoindent
set nocindent
set nosmartindent
set indentexpr=

set nobackup
set noswapfile
set nowrap
set hlsearch
set incsearch
set splitbelow
set splitright
set showcmd
set shiftwidth=4
set tabstop=4


" make Y consistent with D and C (yank til end)
map Y y$

" navigating buffers
nnoremap + :bn<CR>
nnoremap - :bp<CR>
nnoremap _ :bd<CR>

nnoremap ;c :close   <CR>
nnoremap ;h :split   <CR>
nnoremap ;t :vert terminal <CR>
nnoremap ;v :vsplit  <CR>
nnoremap ;w :set invwrap  <CR>

nnoremap ;$ :%s/$\(\w\+\)/${\1:?}/gc<CR>
nnoremap ;; :nohlsearch <CR>
nnoremap ;. :cnext      <CR>
nnoremap ;, :clast      <CR>
nnoremap ;/ :cope       <CR>

" ctrl-n to toggle line numbers
nmap <C-N> :set invnumber<CR>

" resize window
nnoremap <C-H> :wincmd h <CR>:vertical resize -1 <CR>
nnoremap <C-J> :wincmd k <CR>:resize -1 <CR>
nnoremap <C-K> :wincmd k <CR>:resize +1 <CR>
nnoremap <C-L> :wincmd h <CR>:vertical resize +1 <CR>

" delete first character on line and move down
map <F2> @='^xj'<CR>
" comment line with '#' and move down
nmap <F3> @='I#<C-V><Esc>j'<CR>
" delete first character on line and move down
imap <F2> <Esc>@='^xj'<CR>i
" comment line with '#' and move down
imap <F3> <Esc>@='I#<C-V><Esc>j'<CR>i

" on F1 execute the command stored in register 'r'
map <F1> :@r<CR>
map! <F1> <ESC>:@r<CR>
" on F5 store last executed command in register 'r'
map <F5> :let @r = @:<CR>
map! <F5> <ESC>:let @r = @:<CR>
" on F8 clear console and run current file
map <F8> :w <bar> !clear; ./% <CR>
map! <F8> <ESC>:w <bar> !clear; ./% <CR>
" toggle file browser
map <F9> :NERDTreeToggle <CR>
map! <F9> <ESC>:NERDTreeToggle <CR>











