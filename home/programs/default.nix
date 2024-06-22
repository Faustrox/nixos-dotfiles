{ lib, ... }:

{

  imports = [
    ./dunst.nix
    ./git.nix
    ./spicetify.nix
    ./waybar.nix
    ./wofi.nix
    ./zsh.nix
  ];

}
