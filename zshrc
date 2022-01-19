# The following lines were added by compinstall
zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/home/flugsio/.zshrc'
# Make lowercase completion also match uppercase.
# Only if there's no case sensitive matches, the '' part. man zshcompsys
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
autoload -Uz compinit
compinit
if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
fi
# End of lines added by compinstall

HISTFILE=~/.histfile
HISTSIZE=500000
SAVEHIST=500000
# man zshoptions
setopt HIST_IGNORE_DUPS
setopt appendhistory autocd
setopt histignorespace
#setopt no_beep
setopt auto_cd
setopt multios
setopt cdablevarS
unsetopt nomatch
stty -ixon

# autoenv overrides built in cd
[[ -e /usr/share/autoenv/activate.sh ]] && . /usr/share/autoenv/activate.sh
[[ -e /usr/share/doc/pkgfile/command-not-found.zsh ]] && . /usr/share/doc/pkgfile/command-not-found.zsh
[[ -e ~/.zsh_theme ]] && . ~/.zsh_theme
[[ -e ~/.bash_aliases ]] && . ~/.bash_aliases
[[ -e ~/.api_keys ]] && . ~/.api_keys

if command -v ruby >/dev/null 2>&1; then
  # saves 100ms in total, rm ~/.gem/ruby/current when updating system ruby
  [[ /var/log/pacman.log -nt ~/.gem/ruby/current.touch ]] && rm ~/.gem/ruby/current
  [[ -e ~/.rbenv_init ]] && . ~/.rbenv_init
fi

export PATH=$HOME/bin:$HOME/bin/games:$HOME/code/scripts:$HOME/.cargo/bin:$PATH

export EDITOR='vim'
export PAGER='less'
if [ `hostname` = "toldi" ]; then
  export LC_PAPER=sv_SE.UTF-8
fi
export LYNX_CFG=~/.config/lynx/lynx.cfg
export LYNX_LSS=~/.config/lynx/lynx.lss

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

if [[ "$SSH_AUTH_SOCK" != /tmp/ssh-* ]]; then
  if [ -e ~/.ssh/id_rsa ]; then
    eval $(keychain --quick --eval id_rsa --nogui --quiet)
  fi
fi

if [ -z "$RUST_SRC_PATH" ]; then
  if command -v rustc >/dev/null 2>&1; then
    export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
  fi
fi

bindkey -v

# extra vi bindings
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

bindkey '\e.' insert-last-word

# TODO: delete cache files
if [ -z "$SKIP_H" ]; then
  # http://zsh.sourceforge.net/Doc/Release/Functions.html
  # stores the last command, to use with the h function
  # This does not work well with nested programs, but it works well with last-command
  mkdir -p ~/.cache/h
  function preexec {
    echo $1 | cut -d' ' -f1 > ~/.cache/h/$$
  }
fi

# widget: http://zsh.sourceforge.net/Guide/zshguide04.html#l103
zle -N browsedir
function browsedir() {
  local dir=$( (cat ~/.config/zlinks 2>/dev/null || find ~/code ~/code/promote-docker/repos -maxdepth 1 -type d) | fzf | sed 's/ *#.*$//')
  if [ "$HOME/debug" = "$dir" ]; then
    local dir=$(find "$dir" -maxdepth 1 -type d | fzf | sed 's/ *#.*$//')
    if [ "$HOME/debug" = "$dir" ]; then
      BUFFER="mkde "
      zle .end-of-line
    elif [ -n "$dir" ]; then
      if [ -f "$dir/log.md" ]; then
        BUFFER="cd $dir; vim log.md"
      else
        BUFFER="cd $dir; ranger"
      fi
      zle .accept-line
    fi
  elif [ -n "$dir" ]; then
    BUFFER="cd $dir"
    zle .accept-line
  fi
}

function checkprev() {
  local result=$(grep "prev_ansible_host" ~/donjon/ansible/{d,s,p}*/host_vars/* | sed 's/"//g;s/.*ansible\/\(.*\)\/host_vars\//\1 /;s/:ansible_host:\s*/ /' | awk '{print $3 "\t" $1 "\t" $2}' | fzf)
  local ip=$(echo $result | cut -f1)
  local cmd="tail -F /opt/promote/shared/log/nginx_access*.log /var/log/assessor/nginx_access*.log"
  if [ -n "$ip" ]; then
    ssh $SPUSER@$ip $cmd
  fi
}

zle -N findserver
function findserver() {
  local cmd=""
  if [ -e ~/donjon/ansible ]; then
    local result=$(grep "^ansible_host" ~/donjon/ansible/{d,s,p}*/host_vars/* | sed 's/"//g;s/.*ansible\/\(.*\)\/host_vars\//\1 /;s/:ansible_host:\s*/ /' | awk '{print $3 "\t" $1 "\t" $2}' | fzf)
    local ip=$(echo $result | cut -f1)
    local universe=$(echo $result | cut -f2)
    local name=$(echo $result | cut -f3 | sed 's/:.*ansible_host://')
    #local cmd=$(cat ~/.config/zcommands | fzf | sed 's/ *#.*$//' | sed 's# LOG# | tee ~/debug/latest/$(datei)_'$universe-$name'.log#')
    if [ -n "$ip" ]; then
      k=$(grep ansible_ssh_private_key_file ~/donjon/ansible/development/group_vars/all | grep -Po '(?<=")[^"]*')
      cmd="grep ansible_become ~/donjon/ansible/$universe/host_vars/$name; ssh -i ~/$k $SPUSER@$ip $cmd"
    fi
  else
    if [ -e ~/.donjon ]; then
      local mount="mount ~/donjon;"
    else
      local mount="mount_donjon;"
    fi
    cmd="$mount chmod 0600 ~/donjon/????/??????????????.key; ssh-add ~/donjon/????/??????????????.key"
  fi
  if [ -n "$cmd" ]; then
    BUFFER=$cmd
    zle .accept-line
  fi
}

zle -N wrap
function wrap() {
  if echo "$BUFFER" | grep development -q; then
    local new=$(echo "$BUFFER" | sed 's/development/$i/')
    BUFFER="for i in development staging production; do $new; done"
    CURSOR=39
  else
    BUFFER="for i in {1..5}; do $BUFFER; done"
    CURSOR=15
  fi
}

# execute line but keep buffer
zle -N accepthold
function accepthold() {
  zle .accept-and-hold
}
bindkey '^V' browsedir
bindkey '^G' findserver
bindkey '^H' wrap
bindkey '^[' accepthold # alt+return

export KEYTIMEOUT=1
# can only be used when using ruby 2.7+
export RUBYOPT='-W:deprecated'
export LOG4J_FORMAT_MSG_NO_LOOKUPS=true

