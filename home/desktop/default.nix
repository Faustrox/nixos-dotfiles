{ lib, ... }:

{
  
  imports = [
    ./gnome.nix
    ./hyprland.nix
  ];


  services.kdeconnect.enable = true;

}