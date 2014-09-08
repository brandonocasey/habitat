#! /bin/sh

if [ "$#" -ne "3" ] || [ -z "$1" ] ||  [ -z "$2" ]; then
    echo "Must pass args <source> <dest> <backup>"
    return 2
fi
source="$1"; shift
dest="$1"; shift
backup_dir="$1"; shift

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
