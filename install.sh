#!/usr/bin/env bash

home="$HOME"
base_dir="$home/.dotfiles"
backup_dir="$home/.dotfiles/backup"
vim_plugins_dir="$home/.vim/bundle"
vundle_dir="$vim_plugins_dir/Vundle.vim"

# don't include all of .vim, it winds up re-downloading plugins if you do it
# that way.
include=(
    .bash_profile
    .bashrc
    .screenrc
    .tmux.conf
    .vim/pack
    .vim/ftplugin
    .vimrc
)

if [[ -d "$backup_dir" ]] ; then
    echo "removing previous backup at $backup_dir"
    rm -rf "$backup_dir"
fi

echo "backing up existing dotfiles into $backup_dir"
mkdir -p "$backup_dir"
for filename in ${include[@]}; do
    source_path="$base_dir/$filename"
    dest_path="$home/$filename"
    backup_path="$backup_dir/$filename"
    echo "file name:   $filename"
    echo "source path: $source_path"
    echo "dest path:   $dest_path"
    echo "backup path: $backup_path"

    # if a file doesn't actually exist in the repo, do nothing.
    if [[ ! -a "$source_path" ]]; then
        echo "no file found at source path $source_path, skipping"
        continue
    fi

    # back up existing dotfiles, just for safety
    if [[ -a "$dest_path" ]]; then
        if [[ -h "$dest_path" ]]; then
            # existing file is a symlink. delete it.
            echo "removing old link at $dest_path"
            rm "$dest_path"
        else
            # existing file is an original preferences file. archive it.
            echo "archiving existing preferences file at $dest_path"
            if [[ ! -d $(dirname "$backup_path") ]]; then
                mkdir -pv $(dirname "$backup_path")
            fi
            mv -v "$dest_path" "$backup_path"
        fi
    fi

    if [[ ! -d $(dirname "$dest_path") ]]; then
        mkdir -p $(dirname "$dest_path")
    fi

    # symlink in the versioned dotfiles.
    ln -sv "$source_path" "$dest_path"
    echo "--------------------------------------------------------------------------------"
done

if [[ ! -d "$vim_plugins_dir" ]]; then
    mkdir -p "$vim_plugins_dir"
fi

# setup Vundle
if [[ ! -d $vundle_dir ]]; then
    echo "cloning Vundle"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

echo "installing Vim plugins"
vim +PluginInstall +qall
