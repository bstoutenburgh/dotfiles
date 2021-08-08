#!/bin/bash

set -e

LOCAL_BIN="${HOME}/.local/bin"
[[ ":$PATH:" != *"${LOCAL_BIN}"* ]] && PATH="${LOCAL_BIN}:${PATH}"

sudo apt-get remove ansible --yes
sudo apt-get autoremove --yes
sudo apt-get update

sudo apt-get install --yes git make python3-pip

python3 -m pip install --user --upgrade pip
python3 -m pip install --user --upgrade pipx

if ! command -v ansible >/dev/null 2>&1; then
  pipx install --include-deps ansible
else
  pipx upgrade --include-injected ansible
fi

pipx inject ansible argcomplete
pipx inject ansible psutil       # gnome-* for gsettings commands
