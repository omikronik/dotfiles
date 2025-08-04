#!/usr/bin/env fish

function log
    # use -a to always print, else it will only log in verbose mode
    argparse a/always e/error s/success i/info w/warning -- $argv
    or return

    set -l ALWAYS (set -q _flag_always; and echo true; or echo false)
    set -l ERROR (set -q _flag_error; and echo true; or echo false)
    set -l SUCCESS (set -q _flag_success; and echo true; or echo false)
    set -l INFO (set -q _flag_info; and echo true; or echo false)
    set -l WARNING (set -q _flag_warning; and echo true; or echo false)

    if $ALWAYS = true; or $VERBOSE = true
        if test $ERROR = true
            set_color red
            echo $argv
            set_color normal
        else if test $SUCCESS = true
            set_color green
            echo $argv
            set_color normal
        else if test $INFO = true
            set_color blue
            echo $argv
            set_color normal
        else if test $WARNING = true
            set_color yellow
            echo $argv
            set_color normal
        end

    end
end

function tests
    set -l TESTPATH "$DOTFILES_CONFIG_PATH"slinker_test_folder/
    set -l CONFTESTPATH "$CONFIG_BASE_PATH"slinker_test_folder/

    log -a -i "Setting up test environment..."

    # Clean up existing test directories (suppress errors if they don't exist)
    if test -d "$CONFTESTPATH"
        rm -rf "$CONFTESTPATH"
        log -a -i "Removed existing config test folder"
    end

    if test -d "$TESTPATH"
        rm -rf "$TESTPATH"
        log -a -i "Removed existing dotfiles test folder"
    end

    # Create fresh test directory
    mkdir -p "$TESTPATH"
    log -a -i "Created test directory: $TESTPATH"

    # Create test file 1
    touch "$TESTPATH"test1_dotfile_config_folder_does_not_exist.txt
    log -a -i "Created test file 1"

    # Ensure test file 2 doesn't exist (for negative test)
    if test -f "$TESTPATH"test2_does_not_exist.txt
        rm "$TESTPATH"test2_does_not_exist.txt
    end
    log -a -i "Ensured test file 2 doesn't exist (for error testing)"

    log -a -i "Running symlink tests..."
    log -a -i "=========================="

    # Test 1: Should succeed
    create-symlink \
        test1_dotfile_config_folder_does_not_exist.txt \
        $TESTPATH \
        $CONFTESTPATH

    # Test 2: Should fail (file doesn't exist)
    create-symlink \
        test2_does_not_exist.txt \
        $TESTPATH \
        $CONFTESTPATH

    log -a -i "Tests completed"
end

function create-symlink
    set file_to_link $argv[1]
    set dot_location $argv[2]
    set target_location $argv[3]

    log -a -i INFO: running create-symlink for $file_to_link
    log -a -i "==============================="
    # check if the dotfile exists. also proves
    if test -e $dot_location$file_to_link
        log INFO: dotfile $dot_location$file_to_link exists
    else
        log -a ERROR: dotfile $file_to_link does not exist
        if test $DRY_RUN != true
            exit
        end
    end

    # check if target location exists
    # else create it
    if test -e $target_location
        log Info: target $target_location exists
    else
        if test $DRY_RUN = false
            mkdir -p $target_location
        end
        log -a Info: created $target_location
    end

    # check if there is already a symlink with the targets name
    if test -L $target_location$file_to_link
        log -a -w Warning: symlink for $file_to_link exists, skipping.(set_color normal)
    else
        # create symlink
        if test $DRY_RUN != true
            ln -s $dot_location$file_to_link $target_location
            # now test for symlink
            if test -L $target_location$file_to_link
                log -a -s Success: created symlink for $file_to_link(set_color normal)
            else
                log -a -e Error: Symlink creation failed
            end
        else
            log -i -w Warning: dry run mode, did not attempt link
        end

    end

    echo \n
end

argparse d/dry-run v/verbose t/test -- $argv
or return

set -g DRY_RUN (set -q _flag_dry_run; and echo true; or echo false)
set -g VERBOSE (set -q _flag_verbose; and echo true; or echo false)
set -g TEST_MODE (set -q _flag_test; and echo true; or echo false)

if $DRY_RUN = true
    log -a -i Running Slinker in dry run mode
    log -a -i "==============================="
else
    log -a -i Running Slinker
    log -a -i "==============================="
end

set -g CONFIG_BASE_PATH ~/.config/
set -g DOTFILES_PATH ~/dotfiles/
set -g DOTFILES_CONFIG_PATH "$DOTFILES_PATH".config/

echo "$DOTFILES_PATH"kitty/ 
echo "$CONFIG_BASE_PATH"kitty/

if test $TEST_MODE = true
    tests
else
    create-symlink \
        kitty.conf \
        "$DOTFILES_CONFIG_PATH"kitty/ \
        "$CONFIG_BASE_PATH"kitty/

    create-symlink \
        current-theme.conf \
        "$DOTFILES_CONFIG_PATH"kitty/ \
        "$CONFIG_BASE_PATH"kitty/

    create-symlink \
        kanagawa-paper.conf \
        "$DOTFILES_CONFIG_PATH"kitty/themes/ \
        "$CONFIG_BASE_PATH"kitty/themes/

    create-symlink \
        .wezterm.lua \
        "$DOTFILES_PATH" \
        ~/

    create-symlink \
        .tmux.conf \
        "$DOTFILES_PATH" \
        ~/

    create-symlink \
        .zshrc \
        "$DOTFILES_PATH" \
        ~/

    create-symlink \
        init.lua \
        "$DOTFILES_CONFIG_PATH"nvim/ \
        "$CONFIG_BASE_PATH"nvim/

    create-symlink \
        init.lua \
        "$DOTFILES_CONFIG_PATH"nvim/ \
        "$CONFIG_BASE_PATH"nvim/

    create-symlink \
        init.lua \
        "$DOTFILES_CONFIG_PATH"nvim/ \
        "$CONFIG_BASE_PATH"nvim/

    create-symlink \
        alacritty.toml \
        "$DOTFILES_CONFIG_PATH"alacritty/ \
        "$CONFIG_BASE_PATH"alacritty/

    create-symlink \
        config.fish \
        "$DOTFILES_CONFIG_PATH"fish/ \
        "$CONFIG_BASE_PATH"fish/

    create-symlink \
        hyprland.conf \
        "$DOTFILES_CONFIG_PATH"hypr/ \
        "$CONFIG_BASE_PATH"hypr/
    
    create-symlink \
        hyprpaper.conf \
        "$DOTFILES_CONFIG_PATH"hypr/ \
        "$CONFIG_BASE_PATH"hypr/

    create-symlink \
        config.jsonc \
        "$DOTFILES_CONFIG_PATH"waybar/ \
        "$CONFIG_BASE_PATH"waybar/

    create-symlink \
        style.css \
        "$DOTFILES_CONFIG_PATH"waybar/ \
        "$CONFIG_BASE_PATH"waybar/
end
