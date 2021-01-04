
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias dirs="dirs -v"

alias l='ls'
alias ll='ls -al'
alias la='ls -al'
alias lh='ls -sShr --format=single-column'

alias hgrep="history | grep"

alias vimf=vimfind

alias wdocker='watch -n 1 docker ps'
alias dockerrm='docker container rm -f $(docker container ps -aq)'

alias dl='youtube-dl -i'
alias dl480='youtube-dl -i -f "[height <= 480][tbr<=500]"'
alias dl720='youtube-dl -i -f "[height <= 720][tbr<=500]"'
alias dlmp3='youtube-dl -i -x --audio-format mp3 '

alias s='mpsort s'
