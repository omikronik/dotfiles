#!/usr/bin/env fish

function log
    # use -a to always print, else it will only log in verbose mode
    argparse a/always -- $argv
    or return

    set -l ALWAYS (set -q _flag_always; and echo true; or echo false)
    if $ALWAYS = true; or $VERBOSE = true
        echo $argv
    end
end

function create-symlink
    echo \n-------------------------------
    set file_to_link $argv[1]
    set dot_location $argv[2]
    set target_location $argv[3]

    # check if the dotfile exists. also proves
    if test -e $dot_location$file_to_link
        log INFO: dotfile $dot_location$file_to_link exists
    else
        log -a ERROR: dotfile $file_to_link does not exist
        if $DRY_RUN = false
            exit
        end
    end

    # check if target location exists
    # else create it
    if test -e $target_location 
        log INFO: target $target_location exists
    else
        if $DRY_RUN = false
            mkdir -p $target_location
        end
        log -a INFO: created $target_location
    end

    # check if there is already a symlink with the targets name
    if test -L $target_location$file_to_link
        
    end
end

argparse d/dry-run v/verbose -- $argv
or return

set -g DRY_RUN (set -q _flag_dry_run; and echo true; or echo false)
set -g VERBOSE (set -q _flag_verbose; and echo true; or echo false)

if $DRY_RUN = true
    echo (set_color red)Running Slinker in dry run mode
    echo -------------------------------(set_color normal)
else
    echo (set_color red)Running Slinker
    echo -------------------------------(set_color normal)
end

set -g CONFIG_BASE_PATH ~/.config/
set -g DOTFILES_PATH ~/dotfiles/
set -g DOTFILES_CONFIG_PATH "$DOTFILES_PATH".config/

create-symlink \
test.txt \
"$DOTFILES_CONFIG_PATH"slinker_test_folder/ \
"$CONFIG_BASE_PATH"slinker_test_folder/ \


create-symlink \
test2_dotfile_config_folder_does_not_exist.txt \
"$DOTFILES_CONFIG_PATH"slinker_test_folder/ \
"$CONFIG_BASE_PATH"slinker_test_folder/ \

create-symlink \
test3_does_not_exist.txt \
"$DOTFILES_CONFIG_PATH"slinker_test_folder/ \
"$CONFIG_BASE_PATH"slinker_test_folder/ \


