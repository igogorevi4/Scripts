# shell colors
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagaced
#export PS1="\[\e[32m\]\h\[\e[36m\]:\[\e[33m\]\W\[\e[m\] \[\e[32m\]\u\[\e[m\]\[\e[36m\]\\$\[\e[m\] "
export PS1="\[\e[32m\]\u\[\e[m\]\[\e[33m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]\[\e[33m\]:\[\e[m\]\[\e[32m\]\W\[\e[m\]\[\e[33m\]\\$\[\e[m\] "
#\h:\W \u\$

# Grep options
#alias grep='grep -n'
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;31;40'

# login options
#source ~/.vimrc

###
# my aliases
###
alias ll='ls -la'
alias myip='curl -s https://ipinfo.io/ip'
alias now='date +%T\ %d-%m-%Y'
alias weather='curl -s wttr.in'
alias gsp='head -c24 < /dev/random | base64'		# generate strong password
alias hg='history | grep'
# kubernetes
alias k='kubectl'
alias kgp='kubectl get pod -n'
alias klog='kubectl logs -f -n'
#alias ps5=`ps aux | awk '{print $6/1024 " MB\t\t" $11}' | sort -rn | head -n5`
# git 
alias gb='git branch'
alias gc='git checkout'
alias gagc='git add . && git commit -m'
alias gs='git status -s'
