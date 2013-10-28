#!/usr/bin/env bash

BACKUP_DIR="$HOME/.dotfiles_backup"
BASE_DIR="$HOME/.dotfiles"
INCLUDE=".bashrc .vimrc .vim"

echo "backing up existing dotfiles into $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
for FNAME in $INCLUDE; do
	# if a file doesn't actually exist in the repo, do nothing.
    if [[ ! -a "$BASE_DIR/$FNAME" ]]; then
		echo "WARNING:  file $BASE_DIR/$FNAME does not exist"
		continue
	fi

	# back up existing dotfiles, just for safety
	FULLPATH="$HOME/$FNAME"
	if [[ -a "$FULLPATH" && ! -h "$FULLPATH" ]]; then
		echo "mv $FULLPATH -> $BACKUP_DIR/$FNAME"
		mv "$FULLPATH" "$BACKUP_DIR/$FNAME"
	fi

	# symlink in the versioned dotfiles.
	echo "ln $BASE_DIR/$FNAME" "$HOME/$FNAME"
	ln -sf "$BASE_DIR/$FNAME" "$HOME/$FNAME"
done
