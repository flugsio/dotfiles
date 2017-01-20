# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/home/flugsio/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

HISTFILE=~/.histfile
HISTSIZE=30000
SAVEHIST=30000
# man zshoptions
setopt HIST_IGNORE_DUPS
setopt appendhistory autocd
setopt histignorespace
#setopt no_beep
setopt auto_cd
setopt multios
setopt cdablevarS
stty -ixon

[[ -e /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh
[[ -e /home/flugsio/.gem/ruby/2.4.0/gems/tmuxinator-0.9.0/completion/tmuxinator.zsh ]] && source /home/flugsio/.gem/ruby/2.4.0/gems/tmuxinator-0.9.0/completion/tmuxinator.zsh

source ~/.zsh_theme

[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases
[[ -f ~/.api_keys ]] && . ~/.api_keys

export PATH=$HOME/bin:$HOME/code/scripts:$PATH

export EDITOR='vim'
export LC_PAPER=sv_SE.UTF-8
export LYNX_CFG=~/.config/lynx/lynx.cfg
export LYNX_LSS=~/.config/lynx/lynx.lss

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

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

export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"
eval "$(rbenv init -)"

