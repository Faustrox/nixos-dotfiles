{ lib, ... }:

{
  imports = [ 
    ./gnome.nix
    ./hyprland.nix
  ];

  gnome.wayland = lib.mkDefault true;

}