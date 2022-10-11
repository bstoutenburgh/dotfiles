#!/bin/bash

set -e

# shamelessly adapted from https://stackoverflow.com/a/53454540
function github-authenticated() {
  # Attempt to ssh to GitHub
  ssh -o StrictHostKeyChecking=No -T git@github.com &>/dev/null
  RET=$?
  if [ $RET == 1 ]; then
    # user is authenticated, but fails to open a shell with GitHub
    return 0
  elif [ $RET == 255 ]; then
    # user is not authenticated
    return 1
  else
    echo "unknown exit code in attempt to ssh into git@github.com"
  fi
  return 2
}

echo "⚙ ensuring local bin in PATH"
LOCAL_BIN="${HOME}/.local/bin"
[[ ":$PATH:" != *"${LOCAL_BIN}"* ]] && PATH="${LOCAL_BIN}:${PATH}"

echo "⚙ ensuring sudo is ready"
sudo --validate

echo "⚙ ensuring OS packages are set"
if [ -e /etc/debian_version ]; then
  sudo apt-get --remove --yes ansible || true
  sudo apt-get --yes autoremove
  sudo apt-get update
  sudo apt-get install --yes git make python3-pip python3-venv
elif [ -e /etc/redhat-release ]; then
  sudo dnf remove --assumeyes ansible
  sudo dnf clean all
  # I have no memory of why ubuntu 22.04 needed python3-venv added to this step but probably not needed in Fedora
  sudo dnf install --assumeyes git make python3-pip
else
  echo "what is this, mate?"
  exit 1
fi

echo "⚙ ensuring pipx is installed"
python3 -m pip install --user --upgrade pip
python3 -m pip install --user --upgrade pipx

# This script isn't exactly _meant_ to be run again after bootstrapping but might as well upgrade if so
echo "⚙ ensuring ansiable is setup"
if ! command -v ansible >/dev/null 2>&1; then
  pipx install --include-deps ansible
else
  pipx upgrade --include-injected ansible
fi
pipx inject ansible argcomplete
pipx inject ansible psutil       # gnome-* for gsettings commands

# could make this clone or pull based on presense but that would be making lots of assumptions...
REPO_DIR="${REPO_DIR:-${HOME}/repos}"
if [ ! -d "${REPO_DIR}/dotfiles" ]; then
  echo "⚙ cloning the dotfiles repo"

  github-authenticated || {
    echo "You should get the SSH key ready in ~/.ssh/id_rsa or whatever is appropriate"
    exit 1
  }

  mkdir -p "${REPO_DIR}"

  git clone git@github.com:maristgeek/dotfiles "${REPO_DIR}/dotfiles"
fi

echo "🎉 run the appropriate target in ${REPO_DIR}/dotfiles"
