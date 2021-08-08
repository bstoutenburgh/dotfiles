#!/bin/bash
#
# TODO: adapt this to be less ubuntu-clone dependent

set -e

# a role will sort this out eventually but useful for this bootstrapping
[[ ":$PATH:" != *"${HOME}/.local/bin"* ]] && PATH="${HOME}/.local/bin:${PATH}"

if ! command -v ansible >/dev/null 2>&1; then
  sudo -v
  sudo apt install -y python3-venv
  pip install --user pipx
  pipx install --include-deps ansible
  pipx inject ansible argcomplete
else
  pipx upgrade --include-injected ansible
  pipx inject ansible argcomplete
fi

# clone the repo here

ansible-galaxy install -r requirements-galaxy.yml

# ansible-playbook --ask-become-pass desktop.yml
