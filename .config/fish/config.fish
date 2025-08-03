if status is-interactive
    # Commands to run in interactive sessions can go here
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
