{ lib, ... }:

{

  imports = [
    ./dunst.nix
    ./git.nix
    ./spicetify.nix
    ./waybar.nix
    ./wlogout.nix
    ./wofi.nix
    ./zsh.nix
  ];

}
