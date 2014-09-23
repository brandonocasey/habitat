#! /bin/sh

# Deps Management
function habitat_dependancy_management() {
    log.sh --header "Dependancy Management"
    # First Time Stuff
    habitat_install_settings
    local config_setting="$(config.sh --key "update_type" --config "$habitat_config_file")"
    if [ -z "$config_setting" ]; then
        local answer="$(ask.sh --question "Do you want updates?" --answers 'y|yes|n|no')"
        if regex.sh --match "$answer" "^y|yes$" -i; then
            answer="$(ask.sh --question "How do you want updates?" --answers 'auto|ask|inform|manual')"
        else
            answer="manual"
        fi
        config.sh --upsert "update_type" "$answer" --config "$habitat_config_file"
    fi

    # if they don't want to update ever
    if [ "$config_setting" = "manual" ]; then
        return
    fi

    # otherwise check for settings repo updates
    habitat_update_settings "$config_setting"

    # then check for extensions to install
    local config_extensions="$(config.sh --key "extensions" --config "$habitat_config_file")"
    local extension
    for extension in $config_extensions; do
        habitat_install_extension "$extension"
    done

    # Then check for extensions to update
    (while read extension; do
        habitat_update_Extension "$extension" "$config_setting"
    done <<< "$(habitat_extension_directories)")

}

