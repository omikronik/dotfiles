#!/usr/bin/env fish

# usage:
#   ./arch-rebuild.fish apply
#   ./arch-rebuild.fish export
#   ./arch-rebuild.fish help

set cmd $argv[1]
if test -z "$cmd"
  set cmd apply
end

# ensure ansible exists
if not command -q ansible-playbook
  echo "ansible-playbook not found; installing ansible..."
  sudo pacman -S --needed --noconfirm ansible
end

switch $cmd
  case apply
    cd ~/dotfiles/arch/ansible
    ansible-playbook -i inventory.ini arch-setup.yml --ask-become-pass

  case export
    cd ~/dotfiles/arch/ansible
    ansible-playbook -i inventory.ini arch-setup.yml --ask-become-pass --tags export

  case help '-h' '--help'
    echo "arch-rebuild.fish:"
    echo "  apply   - run arch setup"
    echo "  export  - export installed packages to packagelist.txt"
    echo "  help    - show this help"

  case '*'
    echo "unknown command: $cmd"
    echo "try: ./arch-rebuild.fish help"
    exit 1
end
