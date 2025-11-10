#!/usr/bin/env fish

argparse u/update -- $argv
or return

set -g UPDATE (set -q _flag_update; and echo true; or echo false)

if test $UPDATE = true
    nix flake update --flake /home/yasir/dotfiles/nix/framework/
end

sudo nixos-rebuild switch --flake /home/yasir/dotfiles/nix/framework/.#tora
