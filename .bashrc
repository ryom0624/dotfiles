alias la='ls -laFG'
alias ll='ls -laFG'
alias ..='cd ..'
alias hosts='sudo vi /etc/hosts'

alias vu='vagrant up'
alias vh='vagrant halt'
alias vr='vagrant reload'
alias vs='vagrant global-status'
alias sv='ssh 192.168.33.10'

alias cow='fortune|cowsay'

alias yu="mpsyt"

eval "$(rbenv init -)"

export LSCOLORS=gxfxcxdxbxegedabagacad

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
