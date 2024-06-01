{ lib, ... }:

{
  
  imports = [
    ./gnome
    ./hyprland
  ];

  hyprland.setup = lib.mkDefault true;

}