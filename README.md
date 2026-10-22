# Arch i3 Dotfiles: Netrunner

A Cyberpunk 2077-styled i3 desktop for Arch Linux, built for a laptop: low power use, no desktop environment, everything driven from the keyboard. It looks like the breach protocol screen: acid yellow on navy, cyan readouts, red alarms. Two more palettes switch in with one key.

![Morikai i3 desktop: fastfetch, htop and cmatrix tiled over the red Arch wallpaper, i3blocks bar at the bottom](screenshots/morikai-i3-desktop-red-arch.png)

## Features

- **Switchable palettes.** `$mod+t` opens a picker with three palettes:
  - **Netrunner:** acid yellow on navy
  - **Daemon:** cyan and red on deep navy, after [MathisP75/daemon-dotfiles](https://github.com/MathisP75/daemon-dotfiles)
  - **Arasaka:** corporate red with yellow alarms, after [ARCANGEL0/CyberArch-Shell](https://github.com/ARCANGEL0/CyberArch-Shell)

  One switch recolours i3, the bar, rofi, dunst, kitty, GTK apps, the lock screen and the OSDs, swaps the wallpaper, and reloads whatever is running.
- **GTK theme.** GTK 3 and 4 apps (file pickers, Nautilus, libadwaita apps) get a CSS layer on top of Adwaita-dark in the active palette.
- **Kill mode.** `$mod+Shift+x` turns the cursor into a crosshair. Click a window and its process gets SIGTERM, then SIGKILL if it hangs on. A click on the desktop cancels.
- **Street cred.** An optional pacman hook pops a notification for every package you install.
- **CRT power-off.** picom folds closing windows into a line and then a dot, like an old monitor switching off. It takes 0.2 s, so battery cost stays small.
- **Status bar with i3blocks.** It shows the Spotify track, Wi-Fi, IP, battery, free disk space, memory and the clock.
- **On-screen indicators for brightness and volume.** The function keys show a dunst popup with a progress bar.
- **Kitty extras.** A neon trail follows the cursor when it jumps, and the tabs have slanted edges like the in-game panels.
- **Automatic screen lock.** `xss-lock` runs a themed `i3lock-color` before suspend. While locked, it switches to the power-saver profile, pauses media and blanks the screen.
- **Startup apps.** Polish keyboard layout, the NetworkManager tray icon, flameshot for screenshots, and the palette's wallpaper set by feh.

## Keybindings

`Mod` is the Super / Windows key.

| Keys | Action |
|---|---|
| `Mod+Enter` | Terminal (kitty) |
| `Mod+d` | App launcher (rofi) |
| `Mod+t` | Switch palette |
| `Mod+Shift+x` | Kill mode |
| `Mod+Shift+q` | Close window |
| `Mod+o` | Lock screen |
| `Mod+j / k / l / ;` or arrows | Move focus |
| `Mod+Shift+` the same keys | Move window |
| `Mod+h` / `Mod+v` | Split horizontally / vertically |
| `Mod+f` | Fullscreen |
| `Mod+s` / `Mod+w` / `Mod+e` | Stacked / tabbed / split layout |
| `Mod+Shift+space` | Toggle floating |
| `Mod+r` | Resize mode |
| `Mod+1…0` | Switch workspace |
| `F6` / `F7` | Brightness down / up |
| `F1` / `F2` / `F3` | Mute / volume down / up |
| `F8` | Re-detect displays |
| `Mod+Shift+c` / `Mod+Shift+r` | Reload / restart i3 |

## Palettes

Each palette is one shell file in `.config/netrunner/themes/` that sets about a dozen role colours (`NR_BG`, `NR_ACCENT`, `NR_HI`, `NR_ALERT`…) plus 16 terminal colours. `netrunner-theme` fills the `@NR_…@` tokens in `.config/netrunner/templates/` and writes the results where each program looks for them:

| Rendered file | Read by |
|---|---|
| `~/.config/netrunner/current/i3.conf` | i3 config (`include`, for window and bar colours) |
| `~/.config/netrunner/current/i3blocks.conf` | the bar's `status_command` |
| `~/.config/netrunner/current/kitty.conf` | kitty.conf (`include`) |
| `~/.config/netrunner/current/rofi.rasi` | rofi config (`@import`) |
| `~/.config/dunst/dunstrc.d/50-netrunner.conf` | dunst drop-in |
| `~/.config/gtk-3.0/gtk.css`, `~/.config/gtk-4.0/gtk.css` | GTK apps |
| `~/.config/netrunner/current/colors.sh` | lock screen, volume and brightness OSDs |

`NR_WALLPAPER` in the theme file names an image in `~/Pictures/wallpapers`. The switcher points `~/.config/netrunner/current/wallpaper` at it, and i3 loads that link at login.

| Palette | Wallpaper |
|---|---|
| Netrunner | `netrunner-4k.png`, a breach protocol HUD |
| Daemon | `daemon-hongkong-4k.jpg`, Garden Hill, Hong Kong, by [Chi Hung Wong](https://unsplash.com/photos/jODJ4np77W8) (cropped to 16:9) |
| Arasaka | `arasaka-shibuya-4k.jpg`, Udagawacho, Shibuya, by [ayumi kubo](https://unsplash.com/photos/cbwlHckGxAk) (cropped to 16:9) |

Both photos are used under the [Unsplash License](https://unsplash.com/license).

The rendered files stay out of the repo, so switching palettes leaves `git status` clean. To make a new palette, copy a theme file, change the colours and run `netrunner-theme <name>`. From a terminal:

```sh
netrunner-theme --list
netrunner-theme daemon
```

Open GTK apps and rofi pick up the new colours the next time they start. Everything else updates at once.

## Contents

| Path | What |
|---|---|
| `.config/i3/` | i3 config, lock screen, i3blocks scripts (battery, Spotify) |
| `.config/netrunner/` | Palettes and the templates rendered from them |
| `.config/i3status/` | Old status bar config, unused by the bar |
| `.config/picom/` | Compositor |
| `.config/dunst/` | Notification layout (colours come from the palette) |
| `.config/rofi/` | Launcher |
| `.config/kitty/` | Terminal |
| `.config/gtk-3.0/`, `.config/gtk-4.0/` | GTK dark mode settings |
| `.local/bin/` | Palette switcher, kill mode, brightness and volume OSD scripts |
| `extras/pacman/` | Optional pacman hook (needs root, not linked by `install.sh`) |
| `Pictures/wallpapers/` | One wallpaper per palette |
| `screenshots/` | Preview images |

## Install

```sh
sudo pacman -S --needed i3-wm i3blocks i3status xss-lock picom dunst rofi kitty feh \
  brightnessctl wireplumber libpulse playerctl acpi flameshot network-manager-applet dex xorg-xrandr \
  xorg-xprop ttf-jetbrains-mono-nerd ttf-iosevka-nerd
yay -S i3lock-color
git clone https://github.com/fondlet/arch-i3-dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` symlinks each file into `$HOME`. Anything already there gets renamed to `<name>.pre-dotfiles`. The script then renders the current palette (Netrunner on a first install).
Because the live files are symlinks, your edits show up in the repo. Commit and push them from `~/dotfiles`.

### Pacman notifications (optional)

pacman runs its hooks as root. So the script goes in as a root-owned copy, not a symlink into your home directory: a hook your user account can edit would let any program running as you get root.

```sh
sudo install -Dm755 extras/pacman/netrunner-pkg-notify /usr/local/bin/netrunner-pkg-notify
sudo install -Dm644 extras/pacman/netrunner-pkg-notify.hook /etc/pacman.d/hooks/netrunner-pkg-notify.hook
```

Run those two commands again after you change the script in the repo.
