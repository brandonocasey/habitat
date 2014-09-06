#! /bin/sh

function link_files () {
    if [ "$#" -lt "2" ] || [ -z "$1" ] ||  [ -z "$2" ] || [ "$#" -gt "3" ]; then
        echo "Must pass args <source> <dest> <backup>"
        return 2
    fi
    local source="$1"; shift
    local dest="$1"; shift
    local backup_dir
    if [ -n "$1" ]; then
        backup_dir="$1"; shift
    elif [ -n "$custom_backup_dir" ]; then
        backup_dir="$custom_backup_dir"
    else
         echo "Must pass args <source> <dest> <backup>"
        return 2
    fi
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
    exec 3>&-
    ln -s "$source" "$dest"
}

