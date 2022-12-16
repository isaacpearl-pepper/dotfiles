alias c="clear"
alias "vim"="nvim"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Terminal colors (for tmux)
export TERM="screen-256color"

export EDITOR=nvim

# Path to your oh-my-zsh installation.
export ZSH="/Users/ipearl/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="awesomepanda"


# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    macos
    terraform
    aws
    zsh-vi-mode
)

bindkey -v
function zvm_after_select_vi_mode() {
    case $ZVM_MODE in
        $ZVM_MODE_NORMAL)
            VIMODE=""
            VICOLORS="blue"
            ;;
        $ZVM_MODE_INSERT)
            VIMODE=""
            VICOLORS="green"
            ;;
        $ZVM_MODE_VISUAL)
            VIMODE="濾"
            VICOLORS="red"
            ;;
        $ZVM_MODE_VISUAL_LINE)
            VIMODE="礪"
            VICOLORS="red"
            ;;
    esac
    # the svn plugin has to be activated for this to work.
    local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"
    PROMPT='${ret_status}%{$fg_bold[green]%} %{$fg[cyan]%}%~ %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}$(svn_prompt_info)%{$reset_color%}%F{$VICOLORS}$VIMODE %f'

    ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})%{$fg[yellow]%} ✗ %{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}) "

    ZSH_PROMPT_BASE_COLOR="%{$fg_bold[blue]%}"
    ZSH_THEME_REPO_NAME_COLOR="%{$fg_bold[red]%}"

    ZSH_THEME_SVN_PROMPT_PREFIX="svn:("
    ZSH_THEME_SVN_PROMPT_SUFFIX=")"
    ZSH_THEME_SVN_PROMPT_DIRTY="%{$fg[red]%} ✘ %{$reset_color%}"
    ZSH_THEME_SVN_PROMPT_CLEAN=" "
    #PROMPT='%F{$VICOLORS}$VIMODE %f'
}

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

autoload -U +X bashcompinit && compinit
complete -o nospace -C /usr/local/bin/terraform terraform

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH=$HOME/bin/terraform:$PATH

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

complete -o nospace -C /opt/homebrew/Cellar/tfenv/2.2.3/versions/1.2.1/terraform terraform
