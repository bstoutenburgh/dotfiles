# dotfiles

This will be the new repo for bootstrapping and containing dotfiles for personal systems. It _might_ cover some VPSs and things down the line but I think I am going to prefer to keep the infrastructure parts together.

While a tool like yadm might be a better option for dotfiles, I need more experience with Ansible so I might be doing tricks here.

Since I do not have my systems very identical there are going to be multiple playbooks, roughly diving things the systems into _desktop_ and _headless_ classes. Obviously _desktop_ would be towers and laptops while _headless_ is intended mainly for WSL and VMs if I need them for something. That _desktop_ class will get interesting since there is not a consistent OS. This is not intended for work systems, I should really replicate this to their GHE environment, and with that in mind roles here are likely only going to focus on Debian-based setups.

## Getting going

Assumptions made (and some checked) before the `bootstrap.sh` script should be run:

- the system is up and running, should be up to date as far as the package manager is concerned
- an SSH key with access to the repository is setup
  - `~/.ssh` exists and is mode 700
  - `~/.ssh/id_rsa` with appropriate content exists and is mode 600

```
\curl -sSL https://raw.githubusercontent.com/maristgeek/dotfiles/main/scripts/bootstrap.sh  | bash
```

## Notable Inspirations

- https://github.com/dolph/dotfiles
- https://github.com/iancleary/ubuntu-dev-playbook
- https://github.com/maristgeek/dotfiles-legacy
