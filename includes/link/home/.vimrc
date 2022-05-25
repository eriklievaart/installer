
colorscheme default

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

"set noswapfile
set nobackup
set history=200

set hlsearch
set incsearch
set showcmd

set hidden
set nowrap
set linebreak
set sidescroll=1
set sidescrolloff=4
set shiftwidth=4
set tabstop=4
set splitbelow
set splitright

set path=.,~/Development/git/installer/ibin,~/Development/git/cheat/**,**
set suffixesadd=.java,.txt


" @ NORMAL MODE @ "
" disable default binding for showing command history
nmap <silent> q: <Nop>
" make Y consistent with D and C (yank til end of line)
nmap <silent> Y y$
nmap <silent> Q :bd<CR>
nmap S :w <bar> :source %<CR>


nnoremap !x :.!sh<CR>
nnoremap !p !ipsh<CR>

nnoremap <space>c :normal <C-V><C-W>c<CR>
nnoremap <space>d :bd            <CR>
nnoremap <space>h :split         <CR>
nnoremap <space>r :w             <CR>:compiler vimtastic <CR>:set shellpipe= <CR>:set makeef=/tmp/build/vimtastic.log <CR>:make <CR>
nnoremap <space>t :vert terminal <CR>
nnoremap <space>v :vsplit        <CR>
nnoremap <space>w :set invwrap   <CR>

nmap     <space>4       <space>$                <CR>
nnoremap <space>$       :%s/$\(\w\+\)/${\1:?}/gc<CR>
nnoremap <space>.       :cnext                  <CR>
nnoremap <space>,       :clast                  <CR>
nnoremap <space>/       :copen                  <CR>
nnoremap <silent> <space><space> :nohlsearch    <CR>

nmap <S-Up>    gk
nmap <S-Down>  gj
nmap <S-Left>  B
nmap <S-Right> W

nmap <TAB>   >>
nmap <S-TAB> <<

nnoremap <silent> <C-A-Up>    :bp<CR>
nnoremap <silent> <C-A-Down>  :bn<CR>

" ctrl-n to toggle line numbers
nmap <C-N> :set invnumber<CR>

" resize window
nnoremap <C-H> :wincmd h <CR>:vertical resize -1 <CR>
nnoremap <C-J> :wincmd k <CR>:resize -1 <CR>
nnoremap <C-K> :wincmd k <CR>:resize +1 <CR>
nnoremap <C-L> :wincmd h <CR>:vertical resize +1 <CR>

" delete first character on line and move down
nmap <F2> @='^xj'<CR>
" comment line with '#' and move down
nmap <F3> @='I#<C-V><Esc>j'<CR>
" edit the vimrc
nmap <F6> :hide edit $MYVIMRC<CR>
" on F8 clear console and run current file, arguments can be stored in register @a
nmap <F8> :w <Bar> !clear; ./% <C-R>a<CR>
" on F12 copy document to system clipboard
nmap <F12> :0,$ yank + <CR>

" @ insert mode @ "
imap <S-Up>    <C-o>gk
imap <S-Down>  <C-o>gj
imap <S-Left>  <C-o>B
imap <S-Right> <C-o>W
imap <S-Tab>   <C-o><<

imap <C-B>     <C-o>dB
imap <C-F>     <C-o>dW

imap <F1>      <C-o><F1>
imap <F2>      <C-o><F2>
imap <F3>      <C-o><F3>
imap <F4>      <C-o><F4>
imap <F5>      <C-o>:write<cr>
imap <F6>      <C-o><F6>
imap <F7>      <C-o><F7>
imap <F8>      <Esc><F8>
imap <F9>      <C-o><F9>
imap <F10>     <C-o><F10>
imap <F11>     <C-o><F11>
imap <F12>     <C-o><F12>

inoremap <silent> <C-A-Up>    <ESC>:bp<CR>
inoremap <silent> <C-A-Down>  <ESC>:bn<CR>

" @ visual mode @ "
vmap <F12>   "+y
vmap <Tab>   >
vmap <S-Tab> <

" nmap # :normal I#<enter>
nmap # @='I#<C-V><esc>j'<enter>



