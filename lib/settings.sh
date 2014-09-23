#! /bin/sh

# Settings Management
function habitat_install_settings() {
    local settings="$1"; shift
    if [ ! -d "$habitat_settings" ] && [ -z "$settings" ]; then
        local settings="$(ask.sh -question "Where is your settings repo?" --answers 'example|new|.*/.*|(git|http|https)://')"
        log.sh "The user said there settings are going to be: $settings"
    fi

    local repo=""
    if [ "$settings" = "example" ]; then
        repo="brandonocasey/habitat-settings-example"
    elif [ "$settings" = "new" ]; then
        mkdir -p "$habitat_settings"
        : > "$habitat_config_file"
    else
        repo="$settings"
    fi

    if [ -n "$repo" ]; then
        echo "Installing repo $repo under settings"
        repo.sh --download "$repo" "$habitat_settings"
    fi
}

function habitat_update_settings() {
    local type="$1";shift
    local ask=""
    if repo.sh --status "$habitat_settings"; then
        if [ "$type" = "inform" ]; then
            echo "There are updates avilable for your settings repo"
        elif [ "$type" = "ask" ]; then
            ask="$(ask.sh --question "There are updates for your settings do you want them?" --answers "y|yes|n|no")"
        fi
        if [ "$type" = "auto" ] || regex.sh --match "$ask" "y|yes" -i; then
            repo.sh --update "$habitat_settings"
        fi
    fi
}
