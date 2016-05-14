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
# man zshoptions
setopt HIST_IGNORE_DUPS
setopt appendhistory autocd
#setopt no_beep
setopt auto_cd
setopt multios
setopt cdablevarS
stty -ixon

[[ -e /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh

#ZSH=/usr/share/oh-my-zsh

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
export LC_PAPER=sv_SE.UTF-8
export LYNX_CFG=~/.config/lynx/lynx.cfg
export LYNX_LSS=~/.config/lynx/lynx.lss

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"
eval $(keychain --eval id_rsa --nogui --quiet)

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

