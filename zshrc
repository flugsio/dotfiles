# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/home/flugsio/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# tmux window names
export DISABLE_AUTO_TITLE=true

HISTFILE=~/.histfile
HISTSIZE=30000
SAVEHIST=30000
setopt HIST_IGNORE_DUPS
setopt appendhistory autocd

source /usr/share/doc/pkgfile/command-not-found.zsh

# some manual includes
ZSH=/usr/share/oh-my-zsh

# for the theme
source $ZSH/lib/git.zsh
source $ZSH/lib/theme-and-appearance.zsh
source $ZSH/lib/spectrum.zsh
source ~/.zsh_theme

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
#plugins=(git)

#source $ZSH/oh-my-zsh.sh

export PATH=$HOME/bin:$HOME/code/scripts:$PATH

export EDITOR='vim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

bindkey -v

# extra vi bindings
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

bindkey '\e.' insert-last-word

export KEYTIMEOUT=1

export RESOURCE_PATH=http://dl.dropbox.com/u/73192430/Blommor


export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"
eval "$(rbenv init -)"

