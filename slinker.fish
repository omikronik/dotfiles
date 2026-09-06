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

    mkdir -p "$CONFTESTPATH"
    echo "default config" > "$CONFTESTPATH"test1_dotfile_config_folder_does_not_exist.txt
    log -a -i "Created an existing target to back up"

    # Ensure test file 2 doesn't exist (for negative test)
    if test -f "$TESTPATH"test2_does_not_exist.txt
        rm "$TESTPATH"test2_does_not_exist.txt
    end
    log -a -i "Ensured test file 2 doesn't exist (for error testing)"

    log -a -i "Running symlink tests..."
    log -a -i "=========================="

    # Test 1: Existing target should become .bak and be replaced by a symlink.
    create-symlink \
        test1_dotfile_config_folder_does_not_exist.txt \
        $TESTPATH \
        $CONFTESTPATH

    if test -L "$CONFTESTPATH"test1_dotfile_config_folder_does_not_exist.txt; and \
            test -f "$CONFTESTPATH"test1_dotfile_config_folder_does_not_exist.txt.bak
        log -a -s "Success: existing target was backed up and linked."
    else
        log -a -e "Error: backup-and-link test failed."
        return 1
    end

    # Test 2: Re-running against the correct link should be a no-op.
    create-symlink \
        test1_dotfile_config_folder_does_not_exist.txt \
        $TESTPATH \
        $CONFTESTPATH

    # Test 3: A missing source should fail without creating a link.
    if create-symlink \
            test2_does_not_exist.txt \
            $TESTPATH \
            $CONFTESTPATH
        log -a -e "Error: missing-source test unexpectedly succeeded."
        return 1
    else
        log -a -s "Success: missing source was rejected."
    end

    log -a -i "Tests completed"
end

function create-symlink
    set file_to_link $argv[1]
    set dot_location $argv[2]
    set target_location $argv[3]
    set source_path "$dot_location$file_to_link"
    set target_path "$target_location$file_to_link"

    log -a -i INFO: running create-symlink for $file_to_link
    log -a -i "==============================="
    if test -e "$source_path"
        log INFO: dotfile $source_path exists
    else
        log -a -e Error: dotfile $file_to_link does not exist
        if test $DRY_RUN != true
            return 1
        end
        return
    end

    if test -e "$target_location"
        log Info: target $target_location exists
    else
        if test $DRY_RUN = false
            mkdir -p "$target_location"
        end
        log -a Info: created $target_location
    end

    if test -L "$target_path"
        if test (readlink -f "$target_path") = (readlink -f "$source_path")
            log -a -s Success: $file_to_link is already linked correctly.(set_color normal)
            echo \n
            return
        end
    end

    # Preserve existing files and stale links. If a backup already exists,
    # keep it too and select the next numbered name ending in .bak.
    if test -e "$target_path"; or test -L "$target_path"
        set backup_path "$target_path.bak"
        set backup_number 1
        while test -e "$backup_path"; or test -L "$backup_path"
            set backup_path "$target_path.$backup_number.bak"
            set backup_number (math $backup_number + 1)
        end

        if test $DRY_RUN = false
            mv -- "$target_path" "$backup_path"
        end
        log -a -w Warning: moved existing $target_path to $backup_path.(set_color normal)
    end

    if test $DRY_RUN = false
        ln -s "$source_path" "$target_path"
        if test -L "$target_path"
            log -a -s Success: created symlink for $file_to_link.(set_color normal)
        else
            log -a -e Error: symlink creation failed for $file_to_link.
            return 1
        end
    else
        log -a -w Warning: dry run mode, did not create $target_path.(set_color normal)
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
        .luarc.json \
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
        hyprland.lua \
        "$DOTFILES_CONFIG_PATH"hypr/ \
        "$CONFIG_BASE_PATH"hypr/

    create-symlink \
        set-dark-mode.sh \
        "$DOTFILES_CONFIG_PATH"hypr/ \
        "$CONFIG_BASE_PATH"hypr/

    create-symlink \
        hyprlock.conf \
        "$DOTFILES_CONFIG_PATH"hypr/ \
        "$CONFIG_BASE_PATH"hypr/
    
    create-symlink \
        hyprpaper.conf \
        "$DOTFILES_CONFIG_PATH"hypr/ \
        "$CONFIG_BASE_PATH"hypr/

    create-symlink \
        portals.conf \
        "$DOTFILES_CONFIG_PATH"xdg-desktop-portal/ \
        "$CONFIG_BASE_PATH"xdg-desktop-portal/

    create-symlink \
        config.jsonc \
        "$DOTFILES_CONFIG_PATH"waybar/ \
        "$CONFIG_BASE_PATH"waybar/

    create-symlink \
        style.css \
        "$DOTFILES_CONFIG_PATH"waybar/ \
        "$CONFIG_BASE_PATH"waybar/

    create-symlink \
        style.scss \
        "$DOTFILES_CONFIG_PATH"wofi/ \
        "$CONFIG_BASE_PATH"wofi/

    create-symlink \
        style.css \
        "$DOTFILES_CONFIG_PATH"wofi/ \
        "$CONFIG_BASE_PATH"wofi/

    create-symlink \
        zathurarc \
        "$DOTFILES_CONFIG_PATH"zathura/ \
        "$CONFIG_BASE_PATH"zathura/

    create-symlink \
        toggle-laptop-kb.fish \
        "$DOTFILES_PATH" \
        "$CONFIG_BASE_PATH"hypr/scripts/

    create-symlink \
        waybar-kb-status.fish \
        "$DOTFILES_PATH" \
        "$CONFIG_BASE_PATH"waybar/scripts/

    create-symlink \
        dunstrc \
        "$DOTFILES_CONFIG_PATH"/dunst/ \
        "$CONFIG_BASE_PATH"dunst/
end
