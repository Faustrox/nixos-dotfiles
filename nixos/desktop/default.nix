{ lib, ... }:

{
  imports = [ 
    ./plasma.nix
    ./gnome.nix
  ];

  plasma6.enable = lib.mkDefault false;
  plasma6.wayland = lib.mkDefault true;

  gnome.wayland = lib.mkDefault true;

}