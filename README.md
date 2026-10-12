# dotfiles

My i3 desktop on Arch Linux.

| Path | What |
|---|---|
| `.config/i3/` | i3 config, lock screen, i3blocks scripts (battery, Spotify) |
| `.config/i3blocks/`, `.config/i3status/` | Status bar |
| `.config/picom/` | Compositor |
| `.config/dunst/` | Notifications |
| `.config/rofi/` | Launcher |
| `.config/kitty/` | Terminal |
| `.local/bin/` | Brightness and volume OSD scripts |
| `.fehbg`, `Pictures/wallpapers/` | Wallpaper |

## Install

```sh
sudo pacman -S --needed i3-wm i3blocks i3status i3lock xss-lock picom dunst rofi kitty feh \
  brightnessctl wireplumber libpulse playerctl acpi flameshot network-manager-applet dex xorg-xrandr
git clone https://github.com/fondlet/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` symlinks each file into `$HOME`; anything already there is renamed to `<name>.pre-dotfiles`.
Since the live files are symlinks, edits show up in the repo — commit and push them from `~/dotfiles`.
