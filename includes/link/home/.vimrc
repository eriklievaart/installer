
colorscheme default

execute pathogen#infect()

let NERDTreeQuitOnOpen=1

let g:airline#extensions#tabline#enabled = 1
let g:airline_statusline_ontop=0
let g:airline_theme='powerlineish'

" fix airline in tmux
set t_Co=256

" use syntax highlighting on search
syntax on

" don't highlight matching parenthesis
let loaded_matchparen = 0

set noautoindent
set nocindent
set nosmartindent
set indentexpr=

set hidden
set nobackup
set noswapfile
set history=200

set hlsearch
set incsearch
set showcmd

set nowrap
set sidescroll=1
set sidescrolloff=4
set shiftwidth=4
set tabstop=4
set splitbelow
set splitright


"" NORMAL MODE ""
" make Y consistent with D and C (yank til end of line)
map Y y$

" disable default binding for showing command history
map q: <Nop>

" navigating buffers
nnoremap +  :bn<CR>
nnoremap -  :bp<CR>

nnoremap !x :.!bash<CR>

nnoremap <space>c :close         <CR>
nnoremap <space>d :bd            <CR>
nnoremap <space>h :split         <CR>
nnoremap <space>r :w             <CR>:compiler vimtastic <CR>:set shellpipe= <CR>:set makeef=/tmp/build/vimtastic.log <CR>:make <CR>
nnoremap <space>t :vert terminal <CR>
nnoremap <space>v :vsplit        <CR>
nnoremap <space>w :set invwrap   <CR>

nnoremap <space>$       :%s/$\(\w\+\)/${\1:?}/gc<CR>
nnoremap <space><space> :nohlsearch             <CR>
nnoremap <space>.       :cnext                  <CR>
nnoremap <space>,       :clast                  <CR>
nnoremap <space>/       :copen                  <CR>

nmap <TAB> >>
nmap <S-TAB> <<

" ctrl-n to toggle line numbers
nmap <C-N> :set invnumber<CR>

" resize window
nnoremap <C-H> :wincmd h <CR>:vertical resize -1 <CR>
nnoremap <C-J> :wincmd k <CR>:resize -1 <CR>
nnoremap <C-K> :wincmd k <CR>:resize +1 <CR>
nnoremap <C-L> :wincmd h <CR>:vertical resize +1 <CR>


" on F1 execute the command stored in register 'r'
map <F1> :@r<CR>
map! <F1> <ESC>:@r<CR>
" delete first character on line and move down
nmap <F2> @='^xj'<CR>
" comment line with '#' and move down
nmap <F3> @='I#<C-V><Esc>j'<CR>
" on F5 store last executed command in register 'r'
map <F5> :let @r = @:<CR>
map! <F5> <ESC>:let @r = @:<CR>
" on F8 clear console and run current file
map <F8> :w <bar> !clear; ./% <CR>
map! <F8> <ESC>:w <bar> !clear; ./% <CR>
" toggle file browser
map <F9> :NERDTreeToggle <CR>
map! <F9> <ESC>:NERDTreeToggle <CR>



" insert mode
imap <F2>    <C-o>@='^xj'<CR>
imap <F3>    <C-o>@='I#<C-V><Esc>j'<CR>
imap <C-F>   <C-o>dw
imap <S-Tab> <C-o><<


