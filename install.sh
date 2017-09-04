#!/usr/bin/env zsh

#  Install files
local SATAN_FILES=(
  "zshenv" "zprofile" "zshrc"
  "zsh.d" "zsh.d.conf" "zsh.d.modules"
)

#  RC file
local SATAN_RC="${HOME}/.zsh.d/rc.conf"

#  Modules file
local SATAN_MODULES="${HOME}/.zsh.d/modules.conf"

#  Link source path
local SATAN="${PWD#${HOME}/}"

#  Link files
for file in ${SATAN_FILES[@]}; do

  local SRC="${SATAN}/${file}"
  local DST="${HOME}/.${file}"

  if [ -f "${DST}" ]; then
    mv "${DST}" "${DST}.back"
  fi

  echo "linking: ${SRC} -> ${DST}"
  ln -sfh "${SRC}" "${DST}"

done

#  Write default rc file
if [ ! -f "${SATAN_RC}" ]; then
  echo "#  Install dircetory" > "${SATAN_RC}"
  echo "SATAN_INSTALL_DIRECTORY=\"${PWD}\"" >> "${SATAN_RC}"
  echo "" >> "${SATAN_RC}"

  echo "#  Configuration directory" >> "${SATAN_RC}"
  echo "SATAN_CONFIGURATION_DIRECTORY=\"${HOME}/.zsh.d.conf\"" >> \
    "${SATAN_RC}"
  echo "" >> "${SATAN_RC}"

  echo "#  Modules directory" >> "${SATAN_RC}"
  echo "SATAN_MODULES_DIRECTORY=\"${HOME}/.zsh.d.modules\"" >> "${SATAN_RC}"
  echo "" >> "${SATAN_RC}"

  echo "#  Repositories" >> "${SATAN_RC}"
  echo "SATAN_REPOSITORIES=(" >> "${SATAN_RC}"
  echo "  \"satan-core\" \"satan-extra\" \"satan-community\"" >> "${SATAN_RC}"
  echo ")" >> "${SATAN_RC}"
  echo "" >> "${SATAN_RC}"
fi

#  Write default modules file
if [ ! -f "${SATAN_MODULES}" ]; then
  echo "#  Modules are loaded in order" > "${SATAN_MODULES}"
  echo "SATAN_MODULES=(" >> "${SATAN_MODULES}"
  echo "  \"prompt\" \"history\" \"man\" \"ls\" \"git\"" >> \
    "${SATAN_MODULES}"
  echo ")" >> "${SATAN_MODULES}"
fi

#  Create zlogin file
if [ ! -f "${HOME}/.zlogin" ]; then
  touch "${HOME}/.zlogin"
fi

#  Source satan-shell variables
source "${HOME}/.zsh.d/rc.conf"

#  Source activated modules array
source "${HOME}/.zsh.d/modules.conf"

#  Source colors array
source "${HOME}/.zshenv"

#  Source satan-shell functions
source "${HOME}/.zprofile"

#  Index repositories
satan-repository-index

#  Install activated modules
satan-modules-active-install

#  Display ascii art and title
source "${PWD}/ascii.sh"

#  Load the environment
satan-init
