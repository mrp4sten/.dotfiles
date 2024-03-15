#!/bin/bash
# author: mrp4sten

CORRECT_OPTION=true
PROJECT_TYPE_OPTIONS=~/.dotfiles/terminal/zsh/scripts/config-craft/options/project-type-options.txt
CONFIG_FILE_OPTIONS=~/.dotfiles/terminal/zsh/scripts/config-craft/options/config-files-options.txt
PROJECT_TYPE_SELECTED=''

PROJECT_TYPE_CONFIGS_DIR=~/.dotfiles/terminal/zsh/scripts/config-craft/project-type

# Project settings dir
JS_PROJECT_SETTINGS_DIR=${PROJECT_TYPE_CONFIGS_DIR}/js-project-settings
WEBPACK_PROJECT_SETTINGS_DIR=${PROJECT_TYPE_CONFIGS_DIR}/webpack-project-settings

copy_config_file() {
    CONFIG_FILE_TYPES=$(/bin/cat $CONFIG_FILE_OPTIONS | gum filter --placeholder "Select a config file" --limit 1)
    case "$CONFIG_FILE_TYPES-$PROJECT_TYPE_SELECTED" in
    "gitignore-javascript")
        cp ${JS_PROJECT_SETTINGS_DIR}/.gitignore .
        ;;
    "gitignore-webpack")
        cp ${WEBPACK_PROJECT_SETTINGS_DIR}/.gitignore .
        ;;
    "prettierrc-javascript")
        cp ${JS_PROJECT_SETTINGS_DIR}/.prettierrc .
        ;;
    "prettierrc-webpack")
        cp ${JS_PROJECT_SETTINGS_DIR}/.prettierrc .
        ;;
    "htmlhintrc-javascript")
        cp ${JS_PROJECT_SETTINGS_DIR}/.htmlhintrc .
        ;;
    "htmlhintrc-webpack")
        cp ${JS_PROJECT_SETTINGS_DIR}/.htmlhintrc .
        ;;
    "stylelintrc-javascript")
        cp ${JS_PROJECT_SETTINGS_DIR}/.stylelintrc.json .
        ;;
    "stylelintrc-webpack")
        cp ${JS_PROJECT_SETTINGS_DIR}/.stylelintrc.json .
        ;;
    "webpackconfig-webpack")
        cp ${WEBPACK_PROJECT_SETTINGS_DIR}/webpack.config.js .
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
