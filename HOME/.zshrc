export SHELL=/bin/zsh

# Something for me to see where aliases get defined
# Use 256 colors
# export TERM=xterm-256color
export LANG=en_GB.UTF8
# export PYENV_VIRTUALENV_DISABLE_PROMPT=1

## Import locations
export XDG_CONFIG_HOME=$HOME/.config/
export CONFIG_HOME=$XDG_CONFIG_HOME
export ZSH_ENV_HOME=$HOME/
export ZSH_CUSTOM=$CONFIG_HOME/zsh/custom/
export NVIM_HOME=$CONFIG_HOME/nvim

setopt functionargzero
setopt hist_ignore_space

export ZSH_PLUGIN_MANAGER='antigen'
source $CONFIG_HOME/antigen/antigen.zsh

antigen bundle 'zsh-users/zsh-syntax-highlighting'
antigen bundle 'zsh-users/zsh-autosuggestions'
antigen bundle 'zsh-users/zsh-completions'
antigen bundle 'agkozak/zsh-z'
antigen theme spaceship-prompt/spaceship-prompt
antigen apply

# antigen theme robbyrussell

bindkey '^ ' autosuggest-accept
bindkey '^n' autosuggest-accept
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=6'

# # Set up the prompt
# autoload -Uz promptinit; promptinit
# prompt spaceship

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
# bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.local/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit
kitty + complete setup zsh | source /dev/stdin

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

if [[ -d "$XDG_CONFIG_HOME/bin" ]]; then
  export PATH="$XDG_CONFIG_HOME/bin:$PATH"
fi

sources=(
  'aliases'
  'git'
  'spaceship'
)

# if [[ $ZSH_THEME = 'spaceship' ]]; then
#   sources+=('spaceship')
# fi

for s in "${sources[@]}"; do
  source $CONFIG_HOME/zsh/include/${s}.zsh
done

# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'



