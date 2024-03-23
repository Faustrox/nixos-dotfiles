# NixOS dotfiles

<div align="center">

  ![nixos](https://img.shields.io/badge/NixOS-24273A.svg?style=flat&logo=nixos&logoColor=CAD3F5)
  ![nixpkgs](https://img.shields.io/badge/nixpkgs-unstable-informational.svg?style=flat&logo=nixos&logoColor=CAD3F5&colorA=24273A&colorB=8aadf4)
  ![linux kernel](https://img.shields.io/badge/kernel-cahyos-informational.svg?style=flat&logo=linux&logoColor=f4dbd6&colorA=24273A&colorB=b7bdf8)
  ![hyprland](https://img.shields.io/badge/hyprland-stable-informational.svg?style=flat&logo=wayland&logoColor=eed49f&colorA=24273A&colorB=91d7e3)
  ![gnome](https://img.shields.io/badge/gnome-41.0-informational.svg?style=flat&logo=wayland&logoColor=eed49f&colorA=24273A&colorB=91d7e3)

</div>

![Screenshot of Gnome example](https://github.com/Faustrox/nixos-dotfiles/blob/main/assets/gnome-desktop.png)
![Screenshot of Hyprland example](https://github.com/Faustrox/nixos-dotfiles/blob/main/assets/hyprland-desktop.jpg)

# Info

| Component             | Version/Name                |
|-----------------------|-----------------------------|
| Distro                | NixOS                       |
| Kernel                | CachyOS                     |
| Shell                 | Zsh                         |
| Display Server        | Wayland                     |
| WM (Compositor)       | Hyprland/Gnome              |
| Bar                   | Waybar                      |
| Notification          | Dunst                       |
| Launcher              | Rofi-Wayland                |
| Editor                | VSCode                      |
| Terminal              | Kitty                       |
| Fetch Utility         | Fastfetch                   |
| Theme                 | Catppuccin Mocha            |
| Icons                 | Papirus Dark                |
| Font                  | Hack Nerd & FiraCode Nerd   |
| Player                | Spotify                     |
| File Browser          | Nautilus                    |
| Internet Browser      | Google Chrome               |
| Image Editor          | Gimp                        |
| Screenshot            | Grim + Slurp                |
| Recorder              | OBS                         |
| Clipboard             | wl-clipboard + Cliphist + wl-clip-persist    |
| Wallpaper             | swww                        |
| Graphical Boot        | Plymouth + Catppuccin-plymouth |
| Display Manager       | SDDM                        |
<!-- | Color Picker          | Hyprpicker                  | -->
<!-- | Logout menu           | Wlogout                     | -->
<!-- | Containerization      | Podman                      | -->

## ✨ Features

- 🔄 **Reproducible**: Built on NixOS, this configuration can be reproduced on other machines.

- 🖌️ **Consistent**: Nearly every component has been styled to adhere to the Catppuccin Mocha theme.

- 

## ⌨️ Keybindings

### Hyprland

| Key Combination        | Action                       |
|------------------------|------------------------------|
| SUPR + Q               | Close window                 |
| SUPR + M               | Logout                       |
| SUPR + F               | Toggle floating              |
| SUPR + V               | Clipboard                    |
| SUPR + Shift + F       | Toggle fullscreen            |
| SUPR + Shift + S       | Screenshot                   |
| SUPR + C               | Open calculator              |
| SUPR + E               | Open file Manager            |
| SUPR + B               | Open browser                 |
| SUPR + R               | Open launcher                |
| SUPR + Space           | Open terminal                |
| SUPR + Arrows          | Change window focus          |
| SUPR + Shift + Arrows  | Move window                  |
| SUPR + 1-5             | Switch workspace 1st montior |
| SUPR + Shift + 1-5     | Switch workspace 2nd montior |
| SUPR + Ctrl + L or R   | Switch to relative workspace |
| SUPR + Ctrl + Alt + L or R | Move Window to relative workspace |
| SUPR + X               | Special workspace            |
| SUPR + Shift + X       | Move window to special workspace |

Also can hold Supr to be able to drag and resize with mouse.

Common commands:
- `bdiscord-install`: install better discord
- `dayz-launch`: launch `dayz-launcher` on .scripts

NixOS-specific commands:
- `nix-switch`: rebuild and switch your system using current flake
- `nix-switch-update`: rebuild, switch and update your system using current flake
- `nix-clean`: clean system with default configuration (keep 3 generations) 
