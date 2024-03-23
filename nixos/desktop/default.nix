{ lib, ... }:

{
  imports = [ 
    ./gnome.nix
    ./hyprland.nix
    ./portals.nix
  ];

  gnome.wayland = lib.mkDefault true;

}