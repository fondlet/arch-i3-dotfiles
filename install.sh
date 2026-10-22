#!/usr/bin/env bash
# Symlink every file in this repo into $HOME. Existing files are moved to <name>.pre-dotfiles first.
# extras/ holds system files (pacman hook) that need root; see the README.
set -euo pipefail
repo=$(cd "$(dirname "$0")" && pwd)

cd "$repo"
find . -type f ! -path './.git/*' ! -path './extras/*' ! -path './screenshots/*' \
  ! -name install.sh ! -name README.md | sed 's#^\./##' | while read -r f; do
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

# i3, kitty, rofi and dunst include files rendered from the active palette
"$HOME/.local/bin/netrunner-theme" --render
echo "rendered  palette $(cat "${XDG_CONFIG_HOME:-$HOME/.config}/netrunner/current/name")"
