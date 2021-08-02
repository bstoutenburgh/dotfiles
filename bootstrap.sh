#!/bin/bash
#
# TODO: adapt this to be less ubuntu-clone dependent

set -e

if ! command -v ansible >/dev/null 2>&1; then
  sudo -v
  sudo apt install -y python3-venv
  pip install --user pipx
  pipx install --include-deps ansible
  pipx inject ansible argcomplete
  # TODO: Add to PATH if not there?
else
  pipx upgrade --include-injected ansible
fi

# clone the repo here

ansible-galaxy collection install -r requirements.yml

ansible-playbook --ask-become-pass desktop.yml