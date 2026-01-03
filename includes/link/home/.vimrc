




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
let loaded_matchparen = 1

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
set suffixesadd=.java,.txt,.sh,.hashdoc,.ftlh

" visit all buffers and do nothing; removes unread buffer warning
silent bufdo normal! \<nop>
silent buffer 1


" @ NORMAL MODE @ "
" disable default binding for showing command history
nmap <silent> q: <Nop>
" make Y consistent with D and C (yank til end of line)
nmap <silent> Y y$
nmap <silent> Q :bwipeout<CR>
" nmap S :w <bar> :source %<CR>

nmap g<left>  g0
nmap g<right> g$
nmap g/       yiw:vimgrep /\<<C-r>0\>/ **
nmap g*       g/<cr>:copen<cr>

nnoremap !x :.!sh<CR>
nnoremap !p !ipsh<CR>

nmap              <space>4       <space>$                <CR>
nnoremap          <space>b       :leftabove vnew         <CR><C-W><C-W>
nnoremap          <space>c       :normal      <C-V><C-W>c<CR>
nnoremap          <space>d       :bd                     <CR>
nnoremap          <space>f       :silent! %!fmttbl       <CR>
nnoremap          <space>h       :split                  <CR>
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

nnoremap <silent> <A-Up>      yyPk<CR>
nnoremap <silent> <A-Down>    yypk<CR>
nnoremap <silent> <C-A-Up>    :bp<CR>
nnoremap <silent> <C-A-Down>  :bn<CR>

" ctrl-n to toggle line numbers
nmap <C-N> :set invnumber<CR>

" save file
nmap S :w<CR>
" delete first character on line and move down
nmap <F2> @='^xj'<CR>
" comment line with '#' and move down
nmap <F3> @='I#<C-V><Esc>j'<CR>
" run make
nmap <silent> <F4> :!clear<cr> :make %<cr>
" toggle quickfix window
nmap <F5> :call ToggleQuickFix()<cr>
" edit the vimrc
nmap <F6> :hide edit $MYVIMRC<CR>
" on F7 clear console and run current file, arguments can be stored in register @p
nmap <F7> :w <Bar> !clear; ./% <C-R>p<CR>
" on F7 clear console and run current file without arguments
nmap <F8> :w <Bar> !clear; ./%<CR>
" on F12 copy document to system clipboard
nmap <F12> :0,$ yank + <CR>

" @ insert mode @ "
imap <A-Up>    <esc>yyPi
imap <A-Down>  <esc>yypi
imap <S-Up>    <C-o>gk
imap <S-Down>  <C-o>gj
imap <S-Left>  <C-o>B
imap <S-Right> <C-o>W
imap <S-Tab>   <C-o><<

imap <C-B>     <C-o>dB
imap <C-F>     <C-o>dW
imap <C-J>     </><esc>mcT<;yiw`cPla
imap <C-_>     <C-K>hh

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
vmap ,1      Sth1>
vmap ,2      Sth2>
vmap ,3      Sth3>
vmap ,b      Stb>
vmap ,c      Stcenter>
vmap ,d      Stdiv>
vmap ,i      Sti>
vmap ,l      Stli>
vmap ,p      Stp>
vmap ,s      Stspan>
vmap ,td     Sttd>
vmap ,tr     Sttr>
vmap >       I<space><esc>gv
vmap <       Xgv
vnoremap <Tab>    >
vnoremap <S-Tab>  <
vnoremap <space>y "ay
vnoremap <space>p "ap


" @auto commands@
" delete trailing whitespace on save
autocmd BufWritePre * if &filetype != 'markdown' | :%s/\s\+$//e
autocmd BufWinEnter * if getline(1) == '#!/bin/dash' | setfiletype sh | endif
autocmd BufWritePost *.latex :call system('snuggle ' . shellescape(expand('%:p')))

autocmd BufWinEnter *.snippet,*.ftlh setfiletype html
autocmd BufWinEnter *.svg setfiletype svg
autocmd BufWritePost *.snippet,*.svg :call system('curl -s http://localhost:8000/web/push/body -X POST -d "$(cat ' . shellescape(expand('%:p')) . ')" &')
autocmd BufWritePost *.js :call system('curl -s http://localhost:8000/dev/notify -X POST &')
autocmd BufWritePost *.css :call system('curl -s http://localhost:8000/dev/notify -X POST &')
autocmd BufWritePost *.hashdoc :call system('curl -s http://localhost:8000/dev/notify -X POST &')
autocmd BufRead *.hashdoc silent! %!fmttbl

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





" insert mode aliases, digraphs, etc.
imap `1 ₁
imap `2 ₂
imap `3 ₃
imap `4 ₄
imap `5 ₅
imap `6 ₆
imap `7 ₇
imap `8 ₈
imap `9 ₉
imap `0 ₀
imap ``1 ¹
imap ``2 ²
imap ``3 ³
imap ``4 ⁴
imap ``5 ⁵
imap ``6 ⁶
imap ``7 ⁷
imap ``8 ⁸
imap ``9 ⁹
imap ``0 ⁰
imap ``+ ⁺
imap `++ ⁺
imap ``- ⁻
imap `-- ⁻
imap `* →
imap `a (aq)
imap `e e⁻
imap `g (g)
imap `l (l)
imap `o °
imap `s (s)
imap `h+ H⁺
imap `h2o H₂O
imap `h3o+ H₃O⁺

" chemistry
digraph ~~ 8652 "⇌
digraph `` 8652 "⇌

" register digraphs for subscript / superscript letters
digraph 44 8308 "⁴
digraph 55 8309 "⁵
digraph 66 8310 "⁶
digraph 77 8311 "⁷
digraph 88 8312 "⁸
digraph 99 8313 "⁹
digraph ++ 8314 "⁺
digraph -- 8315 "⁻

execute "digraphs as " . 0x2090
execute "digraphs es " . 0x2091
execute "digraphs hs " . 0x2095
execute "digraphs is " . 0x1D62
execute "digraphs js " . 0x2C7C
execute "digraphs ks " . 0x2096
execute "digraphs ls " . 0x2097
execute "digraphs ms " . 0x2098
execute "digraphs ns " . 0x2099
execute "digraphs os " . 0x2092
execute "digraphs ps " . 0x209A
execute "digraphs rs " . 0x1D63
execute "digraphs ss " . 0x209B
execute "digraphs ts " . 0x209C
execute "digraphs us " . 0x1D64
execute "digraphs vs " . 0x1D65
execute "digraphs xs " . 0x2093

execute "digraphs aS " . 0x1d43
execute "digraphs bS " . 0x1d47
execute "digraphs cS " . 0x1d9c
execute "digraphs dS " . 0x1d48
execute "digraphs eS " . 0x1d49
execute "digraphs fS " . 0x1da0
execute "digraphs gS " . 0x1d4d
execute "digraphs hS " . 0x02b0
execute "digraphs iS " . 0x2071
execute "digraphs jS " . 0x02b2
execute "digraphs kS " . 0x1d4f
execute "digraphs lS " . 0x02e1
execute "digraphs mS " . 0x1d50
execute "digraphs nS " . 0x207f
execute "digraphs oS " . 0x1d52
execute "digraphs pS " . 0x1d56
execute "digraphs rS " . 0x02b3
execute "digraphs sS " . 0x02e2
execute "digraphs tS " . 0x1d57
execute "digraphs uS " . 0x1d58
execute "digraphs vS " . 0x1d5b
execute "digraphs wS " . 0x02b7
execute "digraphs xS " . 0x02e3
execute "digraphs yS " . 0x02b8
execute "digraphs zS " . 0x1dbb

execute "digraphs AS " . 0x1D2C
execute "digraphs BS " . 0x1D2E
execute "digraphs DS " . 0x1D30
execute "digraphs ES " . 0x1D31
execute "digraphs GS " . 0x1D33
execute "digraphs HS " . 0x1D34
execute "digraphs IS " . 0x1D35
execute "digraphs JS " . 0x1D36
execute "digraphs KS " . 0x1D37
execute "digraphs LS " . 0x1D38
execute "digraphs MS " . 0x1D39
execute "digraphs NS " . 0x1D3A
execute "digraphs OS " . 0x1D3C
execute "digraphs PS " . 0x1D3E
execute "digraphs RS " . 0x1D3F
execute "digraphs TS " . 0x1D40
execute "digraphs US " . 0x1D41
execute "digraphs VS " . 0x2C7D
execute "digraphs WS " . 0x1D42






