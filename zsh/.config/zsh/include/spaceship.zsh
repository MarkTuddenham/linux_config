# # Prefix
# if [ $IS_SSH ]; then
#   # Prompt replacement symbols
#   export SPACESHIP_PROMPT_DEFAULT_PREFIX='/ '
#   export SPACESHIP_CHAR_SYMBOL='-> '

#   # Git replacement symbols
#   export SPACESHIP_GIT_SYMBOL='git:'

#   export SPACESHIP_GIT_STATUS_UNTRACKED='?'
#   export SPACESHIP_GIT_STATUS_AHEAD='^'
#   export SPACESHIP_GIT_STATUS_BEHIND='v'
#   export SPACESHIP_GIT_STATUS_DIVERGED='<diverged>'

#   # Pyenv
#   SPACESHIP_PYENV_SYMBOL="pyenv:"
# else
#   export SPACESHIP_PROMPT_DEFAULT_PREFIX=' '
# fi

export SPACESHIP_PROMPT_DEFAULT_PREFIX=' ❯ '
export SPACESHIP_PROMPT_ADD_NEWLINE=false
export SPACESHIP_USER_SHOW=needed
export SPACESHIP_HOST_SHOW=true
export SPACESHIP_EXIT_CODE_SHOW=true

# Time
export SPACESHIP_TIME_SHOW=true

export SPACESHIP_VI_MODE_SHOW=true
export SPACESHIP_DIR_TRUNC_REPO=false
export SPACESHIP_DIR_TRUNC_PREFIX='...'


SPACESHIP_PROMPT_ORDER=(
	vi_mode
  user
  host
  dir
  git
  package
  aws
  docker
  venv
  conda
  pyenv
  kubectl
  exec_time
  line_sep
  jobs
  exit_code
  char
)

# Hacks to get RPOMPT on top line :)
function spaceship_rprompt_prefix() {
  echo -n '%{'$'\e[1A''%}'
}

function spaceship_rprompt_suffix() {
  echo -n '%{'$'\e[1B''%}'
}

# RPROMPT
SPACESHIP_RPROMPT_ORDER=(
  rprompt_prefix
  time
  rprompt_suffix
)
