{ lib, ... }:

{
  
  imports = [
    ./gnome.nix
    ./hyprland.nix
  ];

  hyprland.setup = lib.mkDefault true;

}