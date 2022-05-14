# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
# export ZSH_THEME="robbyrussell"
# export ZSH_THEME="afowler"
# export ZSH_THEME="clean"
# export ZSH_THEME="gallifrey"
# export ZSH_THEME="macovsky"
export ZSH_THEME="lukerandall"

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git textmate mercurial)

source $ZSH/oh-my-zsh.sh

# Lines added by divye
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

export PATH=~/bin:$PATH
cdpath=(~ )

#export PROMPT='[%m %~]%# '
export RPROMPT='[%D{%-I:%M:%S %p}]'
alias ipython='ipython -noconfirm_exit'
alias gits='git status'
alias gitc='git commit'


[-f ~/.aliases ] && source ~/.aliases
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

