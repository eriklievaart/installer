
alias dirs="dirs -v"

alias l='ls'
alias ll='ls -al'
alias la='ls -al'
alias lh='ls -sShr --format=single-column'

alias dep="cat ~/Development/repo/index.txt | grep"
alias hgrep="history | grep"
alias grepi="grep -i"

alias vimf='vimfind'
alias vimd='vimfind -d'

alias wdocker='watch -n 1 docker ps'
alias dockerrm='docker container rm -f $(docker container ps -aq)'

alias dl='youtube-dl -i'
alias dl480='youtube-dl -i -f "[height <= 480][tbr<=500]"'
alias dl720='youtube-dl -i -f "[height <= 720][tbr<=500]"'
alias dlmp3='youtube-dl -i -x --audio-format mp3 '

alias s='mpsort s'
alias targets='sed -n "/target/{s/.*name=\"//;s/\".*//;p}" ~/Development/git/ant/master.xml | sort'

