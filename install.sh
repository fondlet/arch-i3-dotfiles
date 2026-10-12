#!/usr/bin/env bash
# Symlink every file in this repo into $HOME. Existing files are moved to <name>.pre-dotfiles first.
set -euo pipefail
repo=$(cd "$(dirname "$0")" && pwd)

cd "$repo"
find . -type f ! -path './.git/*' ! -name install.sh ! -name README.md | sed 's#^\./##' | while read -r f; do
  dest="$HOME/$f"
  mkdir -p "$(dirname "$dest")"
  if [[ -L $dest && $(readlink "$dest") == "$repo/$f" ]]; then
    continue
  fi
  if [[ -e $dest || -L $dest ]]; then
    mv "$dest" "$dest.pre-dotfiles"
    echo "backed up $dest"
  fi
  ln -s "$repo/$f" "$dest"
  echo "linked    $dest"
done
