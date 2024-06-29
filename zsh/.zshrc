export ZSH="$HOME/.oh-my-zsh"

ZSH_DISABLE_COMPFIX=true
CASE_SENSITIVE="false"
# HYPHEN_INSENSITIVE="true"
# DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"

# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time
# zstyle ':omz:update' frequency 13

plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
	fzf
	colored-man-pages
)

source $ZSH/oh-my-zsh.sh

# User configuration
export PATH=~/.npm-global/bin:$PATH

# autocompletion for ros2 & colcon
# eval "$(register-python-argcomplete ros2)"
# eval "$(register-python-argcomplete colcon)"

[ -f /usr/bin/starship ] && eval "$(starship init zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/chris/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/chris/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/chris/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/chris/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

