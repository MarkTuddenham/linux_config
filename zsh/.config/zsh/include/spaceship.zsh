export SPACESHIP_PROMPT_DEFAULT_PREFIX=' > '
export SPACESHIP_PROMPT_ADD_NEWLINE=false
export SPACESHIP_USER_SHOW=always
export SPACESHIP_HOST_SHOW=always
export SPACESHIP_EXIT_CODE_SHOW=true

# Time
export SPACESHIP_TIME_SHOW=true

SPACESHIP_PROMPT_ORDER=(
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
  vi_mode
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
