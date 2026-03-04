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
ZSH_THEME="awesomepanda"

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
    svn
    zsh-vi-mode
)

bindkey -v
function zvm_after_select_vi_mode() {
    case $ZVM_MODE in
        $ZVM_MODE_NORMAL)
            VIMODE="+"
            VICOLORS="blue"
            ;;
        $ZVM_MODE_INSERT)
            VIMODE="+"
            VICOLORS="green"
            ;;
        $ZVM_MODE_VISUAL)
            VIMODE="+"
            VICOLORS="red"
            ;;
        $ZVM_MODE_VISUAL_LINE)
            VIMODE="+"
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

export PATH=$HOME/bin/terraform:$PATH
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

complete -o nospace -C /opt/homebrew/Cellar/tfenv/2.2.3/versions/1.2.1/terraform terraform

# Aliases
alias c="clear"
alias rm="rm -i"
alias "ls"="ls -aG"
alias "vim"="nvim"
alias "gs"="git status"
alias "ga"="git add"
alias "gaa"="git add ."
alias "gc"="git commit"
alias "gp"="git push"
alias "gpn"="git push --no-verify"
alias "gpl"="git pull"
alias "gcm"="git checkout main"
alias "gcma"="git checkout master"
alias "gcb"="git checkout -b"
alias "gco"="git checkout"
alias "gca"="git checkout \$(git for-each-ref --format='%(refname:short)' refs/heads/ | fzf)"
alias "gb"="git branch"
alias "gm"="git merge"
alias "gmm"="git merge main"
alias "gmma"="git merge master"
alias "ghpr"="gh pr create --web"
alias "grpo"="git remote prune origin"

export PATH="$HOME/.local/bin:$PATH"

# Wrap claude so tmux dot clears on exit (Ctrl+C, Ctrl+D, or normal quit)
claude() { command claude "$@"; ~/dotfiles/tmux-agent-state.sh clear 2>/dev/null; }
