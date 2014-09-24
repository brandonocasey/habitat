#! /bin/sh

function habitat_extension_names() {
    local extension
    (while read extension; do
        extension="$(basename "$extension")"
        extension="$(regex.sh -r "$extension" "habitat\-" "")"
        extension="$(regex.sh -r"$extension" "-" "_" -g)"
        echo "$extension"
    done <<< "$(habitat_extension_directories)")
}


function habitat_extension_directories() {
    for author_dir in "$habitat_extensions/"*; do
        for extension in "$author_dir/"*; do
            echo "$extension"
        done
    done
}
