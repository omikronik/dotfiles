if status is-interactive
    # Commands to run in interactive sessions can go here
end

if test -f ~/anthropic_api_key
    set -gx ANTHROPIC_API_KEY (string trim (cat ~/anthropic_api_key))
end

function hconf
    nvim ~/.config/hypr/hyprland.conf
end

function nconf
    nvim ~/.config/nvim/init.lua
end

function lg
    lazygit
end

function ll
ls -la
end

set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket

if status is-interactive
    if test -S "$SSH_AUTH_SOCK"
        # If agent is reachable, only add keys if they aren't already loaded
        ssh-add -l >/dev/null 2>&1
        if test $status -eq 0
            switch $hostname
                case tora
                    ssh-add -q ~/.ssh/id_ed25519_tora 2>/dev/null
                case '*'
                    ssh-add -q ~/.ssh/id_ed25519 2>/dev/null
            end
        end
    end
end
