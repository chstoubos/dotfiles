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

export PATH=~/.npm-global/bin:$PATH

if [ -d /opt/ros/ ]; then
    source /opt/ros/humble/setup.zsh
    eval "$(register-python-argcomplete3 ros2)"
    eval "$(register-python-argcomplete3 colcon)"
fi

[ -f $(which starship) ] && eval "$(starship init zsh)"
