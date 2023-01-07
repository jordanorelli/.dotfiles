#!/usr/bin/env bash

# Configures windows from WSL
if ! uname -a | grep -q WSL; then
    echo "install.sh for windows must be run from WSL" 2>&1
    exit 1
fi

set -e
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PREFS_DIR=$(dirname $SCRIPT_DIR)
echo $PREFS_DIR

while getopts u:a:f: flag
do
    case "${flag}" in
        u) username=${OPTARG};;
    esac
done

function main() {
    if ! [[ $username ]]; then
        echo "Username is required" 2>&1
        usage
        exit 1
    fi

    homedir="/mnt/c/Users/$username"

    if ! [[ -d "$homedir" ]]; then
        echo "Missing expected home directory at '$homedir'" 2>&1
        usage
        exit 1
    fi

    echo "Installing preferences to home directory $homedir"

    vimdir="$homedir/AppData/Local/nvim"
    setup_nvim "$vimdir"
}

function usage() {
    cat <<EOF
usage: install.sh -u username
EOF
}

function setup_nvim() {
    vimdir=$1
    mkdir -vp "$vimdir"
    mkdir -vp "$vimdir/colors"
    echo setting up nvim
    cp "$PREFS_DIR/nvim/init.vim" "$vimdir/init.vim"
    cp "$PREFS_DIR/nvim/colors/jellybeans.vim" "$vimdir/colors"
}

main
