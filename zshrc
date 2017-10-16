# The following lines were added by compinstall
zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/home/flugsio/.zshrc'
autoload -Uz compinit
compinit
# End of lines added by compinstall

HISTFILE=~/.histfile
HISTSIZE=300000
SAVEHIST=300000
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
[[ -e /usr/share/autoenv/activate.sh ]] && . /usr/share/autoenv/activate.sh
[[ -e /usr/share/doc/pkgfile/command-not-found.zsh ]] && . /usr/share/doc/pkgfile/command-not-found.zsh
[[ -e ~/.zsh_theme ]] && . ~/.zsh_theme
[[ -e ~/.bash_aliases ]] && . ~/.bash_aliases
[[ -e ~/.api_keys ]] && . ~/.api_keys

# saves 100ms in total, rm ~/.gem/ruby/current when updating system ruby
[[ /var/log/pacman.log -nt ~/.gem/ruby/current ]] && rm ~/.gem/ruby/current
[[ -e ~/.rbenv_init ]] && . ~/.rbenv_init

export PATH=$HOME/bin:$HOME/bin/games:$HOME/code/scripts:$HOME/.cargo/bin:$PATH

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
  local dir=$(cat ~/.config/zlinks | fzf | sed 's/ *#.*$//')
  if [ -n "$dir" ]; then
    BUFFER="cd $dir"
    zle .accept-line
  fi
}

zle -N findserver
function findserver() {
  local cmd=""
  if [ -e ~/donjon/ansible ]; then
    local ip=$(cat ~/donjon/ansible/*/inventory | grep -v '^\[' | grep -v '^\s*$' | fzf | grep -oP '(?<=ansible_host=).*$')
    if [ -n "$ip" ]; then
      cmd="grep -F '$ip' -B 5 -A 3 ~/donjon/Servers/* -h; ssh deploy@$ip"
    fi
  else
    cmd="mount ~/donjon"
  fi
  if [ -n "$cmd" ]; then
    BUFFER=$cmd
    zle .accept-line
  fi
}
bindkey '^V' browsedir
bindkey '^G' findserver

export KEYTIMEOUT=1

