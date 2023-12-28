#!/bin/bash
# author: mrp4sten

figlet initial config files -f big -c -w 100 | lolcat

CORRECT_OPTION=true
PROJECT_TYPE_OPTIONS=~/.dotfiles/terminal/zsh/scripts/initial-config-files/options/project-type-options.txt
CONFIG_FILE_OPTIONS=~/.dotfiles/terminal/zsh/scripts/initial-config-files/options/config-files-options.txt
PROJECT_TYPE_SELECTED=''

copy_config_file() {
    CONFIG_FILE_TYPES=$(/bin/cat $CONFIG_FILE_OPTIONS | gum filter --placeholder "Select a config file" --limit 1)
    case "$CONFIG_FILE_TYPES-$PROJECT_TYPE_SELECTED" in
    "gitignore-javascript")
        cp ~/.dotfiles/terminal/zsh/scripts/initial-config-files/project-type/js-project-settings/.gitignore .
        ;;
    "prettierrc-javascript")
        cp ~/.dotfiles/terminal/zsh/scripts/initial-config-files/project-type/js-project-settings/.prettierrc .
        ;;
    "gitignore-webpack")
        cp ~/.dotfiles/terminal/zsh/scripts/initial-config-files/project-type/webpack-project-settings/.gitignore .
        ;;
    "prettierrc-webpack")
        cp ~/.dotfiles/terminal/zsh/scripts/initial-config-files/project-type/js-project-settings/.prettierrc .
        ;;
    *)
        echo "Please select a correct option"
        ;;
    esac
}

while $CORRECT_OPTION; do
    PROJECT_TYPE=$(/bin/cat $PROJECT_TYPE_OPTIONS | gum filter --placeholder "Select a project type" --limit 1)
    case "$PROJECT_TYPE" in
    "javascript")
        PROJECT_TYPE_SELECTED="javascript"
        copy_config_file
        CORRECT_OPTION=false
        ;;
    "webpack")
        PROJECT_TYPE_SELECTED="webpack"
        copy_config_file
        CORRECT_OPTION=false
        ;;
    *)
        echo "Please select a correct option"
        ;;
    esac
done
