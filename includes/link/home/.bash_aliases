
alias 192='ifconfig | grep 192'
alias bat='upower --dump | sed -nr "/\/battery/,/^\$/{/percentage/!d;s/.* //;p}"'
alias battery='upower --dump | sed -nr "/\/battery/,/^\$/{/percentage/!d;s/.* //;p}"'
alias lynx='docker run --rm -it -v /home/eazy/Development/git/cheat/lynx.html:/root/bookmarks.html lievaart/lynx'

alias l='ls'
alias la='ls -al'
alias lb='ls -lb'
alias lh='ls -sShr --format=single-column'
alias ll='ls -lh'

alias ..='. ~/.bashrc'

alias dep="cat ~/Development/repo/index.txt | grep"
alias bashrc='vim ~/.bashrc'
alias hgrep="history | grep -i"
alias grepi="grep -i"
alias wps="watch -n 0.5 pgrep -a"
alias findg="find . | grep"

alias todo='cd ~/Development/git/cheat/; vim drive/todo.txt'

alias vima="vim ~/.bash_aliases"
alias vimc="vimfind -c"
alias vimd='vimfind -d'
alias vimf='vimfind -g'
alias vimh='vimfind -h'
alias vimi='vim ~/.config/i3/config'
alias vimp='vimfind -p'
alias vimt="vim *.txt"
alias vimw='vimfind -w'
alias vimrc='vim ~/.vimrc'
alias write='vim "+set wrap" "+set spell"'
complete -F _filedir_xspec write            # fix autocomplete

alias dark='cd $(find ~/Development/git/ -type d -name "ds2"); vim *.txt'

alias dl='yt'
alias dlr='yt --resume'
alias dl480='youtube-dl -i -f "[height <= 480][tbr<=500]"'
alias dl720='youtube-dl -i -f "[height <= 720][tbr<=500]"'
alias dlmp3='youtube-dl -i -x --audio-format mp3 '

alias ncal='ncal -bM'

alias run='dockerctl -r'
alias rund='dockerctl -d'
alias wdocker='watch -n 1 docker ps'
alias dockerrm='docker container rm -f $(docker container ps -aq)'

alias s='mpsort s'
alias targets='sed -n "/target/{s/.*name=\"//;s/\".*//;p}" ~/Development/git/ant/master.xml | sort'

alias v='killall vlc; nohup vlc --quiet "$(ls | sed "/part$/d" | sort -R | tail -n 1)" > /dev/null &'

alias http="python3 -m http.server"
alias ryujinx=/home/eazy/Applications/nintendo/ryujinx/Ryujinx.sh
alias sw="cd $IBIN/python; python3 stopwatch.py"
alias sw1="cd $IBIN/python; python3 stopwatch.py -a 1:"
alias sw2="cd $IBIN/python; python3 stopwatch.py -a 2:"
alias sw3="cd $IBIN/python; python3 stopwatch.py -a 3:"
alias sw4="cd $IBIN/python; python3 stopwatch.py -a 4:"
alias sw5="cd $IBIN/python; python3 stopwatch.py -a 5:"
alias sw6="cd $IBIN/python; python3 stopwatch.py -a 6:"
alias sw7="cd $IBIN/python; python3 stopwatch.py -a 7:"
alias sw8="cd $IBIN/python; python3 stopwatch.py -a 8:"
alias sw9="cd $IBIN/python; python3 stopwatch.py -a 9:"
alias sw10="cd $IBIN/python; python3 stopwatch.py -a 10:"
alias sw11="cd $IBIN/python; python3 stopwatch.py -a 11:"
alias sw12="cd $IBIN/python; python3 stopwatch.py -a 12:"
alias sw13="cd $IBIN/python; python3 stopwatch.py -a 13:"
alias sw14="cd $IBIN/python; python3 stopwatch.py -a 14:"
alias sw15="cd $IBIN/python; python3 stopwatch.py -a 15:"
alias sw16="cd $IBIN/python; python3 stopwatch.py -a 16:"
alias sw17="cd $IBIN/python; python3 stopwatch.py -a 17:"
alias sw18="cd $IBIN/python; python3 stopwatch.py -a 18:"
alias sw19="cd $IBIN/python; python3 stopwatch.py -a 19:"
alias sw20="cd $IBIN/python; python3 stopwatch.py -a 20:"

