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
	fzf
	colorize
	safe-paste
	zsh-autosuggestions
	zsh-syntax-highlighting
	colored-man-pages
	copyfile
	copypath
	copybuffer
	web-search
)

source $ZSH/oh-my-zsh.sh

setopt no_share_history

export GEM_HOME="$HOME/gems"
export PATH=$HOME/.npm-global/bin:$GEM_HOME:$PATH

if [ -d /opt/ros/ ]; then
    source /opt/ros/humble/setup.zsh
    eval "$(register-python-argcomplete3 ros2)"
    eval "$(register-python-argcomplete3 colcon)"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f $(which starship) ] && eval "$(starship init zsh)"
