#! /bin/sh

function link_files () {
    if [ "$#" -ne "3" ] || [ -z "$1" ] ||  [ -z "$2" ] ||  [ -z "$3" ]; then
        echo "Must pass args <backup_dir> <source> <dest>"
        return 2
    fi
    local backup_dir="$1"; shift
    local source="$1"; shift
    local dest="$1"; shift

    exec 3>&1
    if [ ! -d "$backup_dir" ]; then
        mkdir -p "$backup_dir"
    fi
    if [ -f "$dest" ] || [ -d "$dest" ] || [ -L "$dest" ]; then
        if [ -L "$dest" ]; then
            unlink "$dest"
        else
            echo "Backing up $dest to $backup_dir" 1>&3
            mv "$dest" "$backup_dir"
        fi
    fi
        # Close our file descriptor
    exec 3>&-
    ln -s "$source" "$dest"
}

