# работа wget через i2p (не функционирует)
alias wget-i2p='wget -e use_proxy=yes -e http_proxy=192.168.1.2:4444'
# загрузка видео лучшего качества с ютуба. так же пишет субтитры, аннотацию и описание.
alias ydl='youtube-dl -f bestvideo+bestaudio --all-subs --write-info-json --write-annotations  --write-description -i'
alias la='ls -a'
alias g='gvim'
alias rgrep='grep -R'
