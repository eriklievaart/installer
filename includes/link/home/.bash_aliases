
alias lynx='docker run --rm -it -v /home/eazy/Development/git/cheat/lynx.html:/root/bookmarks.html lievaart/lynx'

alias l='ls'
alias ll='ls -l'
alias la='ls -al'
alias lh='ls -sShr --format=single-column'

alias dep="cat ~/Development/repo/index.txt | grep"
alias hgrep="history | grep"
alias grepi="grep -i"
alias findg="find . | grep"

alias todo='cd ~/Development/git/cheat/; vim drive/todo.txt'

alias vima="vim ~/.bash_aliases"
alias vimc="vimfind -c"
alias vimd='vimfind -d'
alias vimf='vimfind -g'
alias vimw='vimfind -w'
alias vimrc='vim ~/.vimrc'

alias dl='yt -i'
alias dl480='youtube-dl -i -f "[height <= 480][tbr<=500]"'
alias dl720='youtube-dl -i -f "[height <= 720][tbr<=500]"'
alias dlmp3='youtube-dl -i -x --audio-format mp3 '

alias ncal='ncal -bM'

alias run='docker run -it'
alias wdocker='watch -n 1 docker ps'
alias dockerrm='docker container rm -f $(docker container ps -aq)'
alias dockerrun='docker run --rm -it '

alias s='mpsort s'
alias targets='sed -n "/target/{s/.*name=\"//;s/\".*//;p}" ~/Development/git/ant/master.xml | sort'


