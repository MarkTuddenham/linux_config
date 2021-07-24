# export ZDOTDIR=$HOME/.config/zsh/

# export XDG_CONFIG_HOME=$HOME/.config/

# export fpath=(~/.config/zsh/completions/ $fpath)

# if [[ $s(command -v rg) ]]; then
#     export FZF_DEFAULT_COMMAND='rg --hidden --ignore .git -g ""'
# fi


# # Determine if we are an SSH connection
# if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
#     export IS_SSH=true
# else
#     case $(ps -o comm= -p $PPID) in
#         sshd|*/sshd) IS_SSH=true
#     esac
# fi
