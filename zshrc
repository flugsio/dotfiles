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

# autoenv overrides built in cd
[[ -e /usr/share/autoenv/activate.sh ]] && source /usr/share/autoenv/activate.sh
[[ -e /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh
[[ -e /home/flugsio/.gem/ruby/2.4.0/gems/tmuxinator-0.9.0/completion/tmuxinator.zsh ]] && source /home/flugsio/.gem/ruby/2.4.0/gems/tmuxinator-0.9.0/completion/tmuxinator.zsh

source ~/.zsh_theme

[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases
[[ -f ~/.api_keys ]] && . ~/.api_keys

export PATH=$HOME/bin:$HOME/code/scripts:$HOME/.cargo/bin:$PATH

export EDITOR='vim'
export LC_PAPER=sv_SE.UTF-8
export LYNX_CFG=~/.config/lynx/lynx.cfg
export LYNX_LSS=~/.config/lynx/lynx.lss

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

eval $(keychain -Q --eval id_rsa --nogui --quiet)

bindkey -v

# extra vi bindings
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

bindkey '\e.' insert-last-word

# widget: http://zsh.sourceforge.net/Guide/zshguide04.html#l103
zle -N browsedir
function browsedir() {
  BUFFER="cd $(cat ~/.config/zlinks | fzf | sed 's/ *#.*$//')"
  zle .accept-line
}
bindkey '^V' browsedir

export KEYTIMEOUT=1

# saves 100ms in total, rm ~/.gem/ruby/current when updating system ruby
[ -e "$HOME/.rbenv_init" ] && source "$HOME/.rbenv_init"

