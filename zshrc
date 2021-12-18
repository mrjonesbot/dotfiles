# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

# extra files in ~/.zsh/configs/pre , ~/.zsh/configs , and ~/.zsh/configs/post
# these are loaded first, second, and third, respectively.
_load_settings() {
  _dir="$1"
  if [ -d "$_dir" ]; then
    if [ -d "$_dir/pre" ]; then
      for config in "$_dir"/pre/**/*~*.zwc(N-.); do
        . $config
      done
    fi

    for config in "$_dir"/**/*(N-.); do
      case "$config" in
        "$_dir"/(pre|post)/*|*.zwc)
          :
          ;;
        *)
          . $config
          ;;
      esac
    done

    if [ -d "$_dir/post" ]; then
      for config in "$_dir"/post/**/*~*.zwc(N-.); do
        . $config
      done
    fi
  fi
}
_load_settings "$HOME/.zsh/configs"

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

export GOPATH=$HOME/go
export GO111MODULE=on

eval "$(rbenv init - zsh)"
# export PATH="/usr/local/opt/libxml2/bin:$PATH"

# nvm() {
#     unset -f nvm
#     export NVM_DIR=~/.nvm
#     [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
#     nvm "$@"
# }

# node() {
#     unset -f node
#     export NVM_DIR=~/.nvm
#     [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
#     node "$@"
# }

# npm() {
#     unset -f npm
#     export NVM_DIR=~/.nvm
#     [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
#     npm "$@"
# }

function docker_compose_container {
  dirname=${PWD##*/}
  container="${COMPOSE_PROJECT_NAME:-$dirname}_$1_1"
  echo $container
}

function docker_compose_exec {
  container=$(docker_compose_container $1)
  shift
  echo -e "\nExecuting the provided command within a running container:"
  echo -e "\n\033[1m\033[36mdocker exec -it \033[92m$container \033[33m$@\033[0m\n"
  docker exec -it $container $@
}

function docker_compose_attach {
  container=$(docker_compose_container $1)
  shift
  echo -e "\nAttaching to a running service:"
  echo -e "\n\033[1m\033[36mdocker attach \033[92m$container \033[0m\n"
  docker attach $container
}

# Add this to your zshrc or bzshrc file
_not_inside_tmux() { [[ -z "$TMUX" ]] }

ensure_tmux_is_running() {
  if _not_inside_tmux; then
    tat
  fi
}

ensure_tmux_is_running

alias dc=docker-compose
alias de=docker_compose_exec
alias da=docker_compose_attach

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform
