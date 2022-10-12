
let g:airline#extensions#tabline#enabled = 1
let g:airline_statusline_ontop=0
let g:airline_theme='powerlineish'

let g:user_emmet_leader_key='<C-p>'

" fix airline in tmux
set t_Co=256

hi Search ctermbg=magenta ctermfg=black
au Filetype * hi Error ctermbg=234 ctermfg=darkred cterm=NONE
au FileType * hi MatchParen ctermbg=darkgray

" use syntax highlighting on search
syntax on

" don't highlight matching parenthesis
" let loaded_matchparen = 1

set noautoindent
set nocindent
set nosmartindent
set indentexpr=
set spellcapcheck=

set nobackup
set history=200
set directory=/tmp/vim/swp

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
set suffixesadd=.java,.txt,.sh


" @ NORMAL MODE @ "
" disable default binding for showing command history
nmap <silent> q: <Nop>
" make Y consistent with D and C (yank til end of line)
nmap <silent> Y y$
nmap <silent> Q :bd<CR>
nmap S :w <bar> :source %<CR>

nmap g<left>  g0
nmap g<right> g$
nmap g/       yiw:vimgrep /\<<C-r>0\>/ **
nmap g*       g/<cr>:copen<cr>

nnoremap !x :.!sh<CR>
nnoremap !p !ipsh<CR>

nmap              <space>4       <space>$                <CR>
nnoremap          <space>c       :normal      <C-V><C-W>c<CR>
nnoremap          <space>d       :bd                     <CR>
nnoremap          <space>r       :w                      <CR>:compiler vimtastic <CR>:set shellpipe= <CR>:set makeef=/tmp/build/vimtastic.log <CR>:make <CR>
nnoremap          <space>s       :split                  <CR>
nnoremap          <space>t       :vert terminal          <CR>
nnoremap          <space>v       :vsplit                 <CR>
nnoremap          <space>w       :set invwrap            <CR>
nnoremap          <space>.       :cnext                  <CR>
nnoremap          <space>,       :cprevious              <CR>
nnoremap          <space>/       :copen                  <CR>
nnoremap          <space>$       :%s/$\(\w\+\)/${\1:?}/gc<CR>
nnoremap <silent> <space><space> :nohlsearch             <CR>
nnoremap <silent> <space><left>  g0
nnoremap <silent> <space><right> g$
nnoremap <silent> <space><down>  gm

nnoremap <S-Up>    gk
nnoremap <S-Down>  gj
nnoremap <S-Left>  B
nnoremap <S-Right> W

nnoremap   <TAB> >>
nnoremap <S-TAB> <<

nnoremap <silent> <C-A-Up>    :bp<CR>
nnoremap <silent> <C-A-Down>  :bn<CR>

" ctrl-n to toggle line numbers
nmap <C-N> :set invnumber<CR>

" enable digraph shortcuts
nmap <F1> :call Digraph()<CR>
" delete first character on line and move down
nmap <F2> @='^xj'<CR>
" comment line with '#' and move down
nmap <F3> @='I#<C-V><Esc>j'<CR>
" edit the vimrc
nmap <F6> :hide edit $MYVIMRC<CR>
" on F8 clear console and run current file, arguments can be stored in register @p
nmap <F8> :w <Bar> !clear; ./% <C-R>p<CR>
" open file explorer
nmap <F9> :Explore<CR>
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


" @auto commands@
" delete trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e
autocmd BufNewFile,BufRead * if getline(1) == '#!/bin/dash' | set filetype=sh | endif

autocmd Filetype css compiler csslint
autocmd Filetype conf set makeprg=/tmp/a/iaac | set errorformat=*error*\ %f:%l%m

function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction

nnoremap \\ :cnext<cr>
nnoremap \. :cnext<cr>
nnoremap \, :cprevious<cr>

nmap <silent> <F4> :!clear<cr> :make %<cr>
nmap <F5> :call ToggleQuickFix()<cr>


function! Digraph()

	imap ,1 <C-K>1s
	imap ,2 <C-K>2s
	imap ,3 <C-K>3s
	imap ,4 <C-K>4s
	imap ,5 <C-K>5s
	imap ,6 <C-K>6s
	imap ,7 <C-K>7s
	imap ,8 <C-K>8s
	imap ,9 <C-K>9s
	imap ,0 <C-K>0s
	imap ,- <C-K>-s
	imap ,+ <C-K>+s

	imap .1 <C-K>1S
	imap .2 <C-K>2S
	imap .3 <C-K>3S
	imap .4 <C-K>4S
	imap .5 <C-K>5S
	imap .6 <C-K>6S
	imap .7 <C-K>7S
	imap .8 <C-K>8S
	imap .9 <C-K>9S
	imap .0 <C-K>0S
	imap .- <C-K>-S
	imap .+ <C-K>+S

endfunction

