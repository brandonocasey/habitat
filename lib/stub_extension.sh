#! /bin/sh
#
# stub_extension.sh
# Copyright (C) 2014 CORPcasey <CORPcasey@Brandon-Caseys-iMac.local>
#
# Distributed under terms of the MIT license.
#

function habitat_stub() {
    local extension_name="$1"; shift
    extension_name="$(echo "$extension_name" | sed -e 's~(_| )~-~g')"
    local underscore_extension_name="$(echo "$extension_name" | sed -e 's~-~_~g' | sed -e 's~habitat_~~g')"
    local extension_dir="$habitat_extensions/$extension_name"
    local extension_file="$extension_dir/extension.habit"
    if [ -d "$extension_dir" ]; then
        echo "Extension Name already exists at $extension_dir"
        return
    fi
    mkdir "$extension_dir"
    touch "$extension_dir/turtle.cfg"
    echo "#! /bin/sh" > "$extension_file"
    echo "" >> "$extension_file"

    echo "function ${underscore_extension_name}_setup() {" >> "$extension_file"
    echo "    # insert setup here if you want" >> "$extension_file"
    echo "    echo \"$extension_name Setup Stub!\"" >> "$extension_file"
    echo "}" >> "$extension_file"
    echo "" >> "$extension_file"

    echo "function ${underscore_extension_name}_deploy() {" >> "$extension_file"
    echo "    # insert deploy here if you want" >> "$extension_file"
    echo "    echo \"$extension_name Deploy Stub!\"" >> "$extension_file"
    echo "}" >> "$extension_file"
    echo "" >> "$extension_file"

    echo "function ${underscore_extension_name}_cleanup() {" >> "$extension_file"
    echo "    # insert cleanup if you want to here" >> "$extension_file"
    echo "    echo \"Optional $extension_name Cleanup Stub!\"" >> "$extension_file"
    echo "}" >> "$extension_file"
    echo "" >> "$extension_file"

    echo "Succesfully stubbed your extension in $extension_file"
}

