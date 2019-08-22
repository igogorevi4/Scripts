# shell colors
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagaced
export PS1="\[\e[32m\]\h\[\e[36m\]:\[\e[33m\]\W\[\e[m\] \[\e[32m\]\u\[\e[m\]\[\e[36m\]\\$\[\e[m\] "
#\h:\W \u\$

# Grep options
#alias grep='grep -n'
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;31;40'

# login options

# yap aliases
alias myip='curl -s https://ipinfo.io/ip'
alias now='date +%T\ %d-%m-%Y'
alias weather='curl -s wttr.in'
