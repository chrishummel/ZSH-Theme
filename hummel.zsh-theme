function collapse_pwd {
  echo $(pwd | sed -e "s,^$HOME,~,")
}

parse_git_dirty() {
  local SUBMODULE_SYNTAX=''
  if [[ $POST_1_7_2_GIT -gt 0 ]]; then
    SUBMODULE_SYNTAX="--ignore-submodules=dirty"
  fi
  if [[ -n $(git status -s ${SUBMODULE_SYNTAX}  2> /dev/null) ]]; then
    echo "%{$fg[yellow]%}$(git rev-parse --abbrev-ref HEAD)"
  else
    echo "%{$fg[cyan]%}$(git rev-parse --abbrev-ref HEAD)"
  fi
}

get_npm_package_version() {
  local JSON=''
  if [[ -f 'package.json' ]]; then
    echo $(node -e "var pkg; try {pkg = require('./package.json').version; } catch(e){ console.log('(npm:ERROR: invalid JSON package.json)')}; if (pkg) console.log('(npm:'+pkg+')')")
  fi
}

SHOW_NVM="${SHOW_NVM:-true}"

get_nvm_status() {

  [[ $SPACESHIP_NVM_SHOW == false ]] && return

  $(type nvm >/dev/null 2>&1) || return

  local nvm_status=$(nvm current 2>/dev/null)
  [[ "${nvm_status}" == "system" ]] && return
  nvm_status=${nvm_status}

  echo -n "%{$fg_bold[magenta]%}"
  echo -n " ["
  echo -n "%{$fg_bold[magenta]%}"
  echo -n "⬡ "
  echo -n "${nvm_status}"
  echo -n "%{$reset_color%}"
  echo -n "%{$fg_bold[magenta]%}"
  echo -n "]"
  echo -n "%{$reset_color%}"
}

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}


local ret_status="%(?:%{$fg_bold[green]%}»:%{$fg_bold[red]%}»%s)"
PROMPT='${ret_status}%{$fg_bold[green]%}%p $(collapse_pwd) %{$fg_bold[blue]%}$(git_prompt_info)%{$reset_color%}$(get_nvm_status) %{$fg_bold[blue]%}$ %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%})"
