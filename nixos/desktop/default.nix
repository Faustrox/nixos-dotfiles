{ lib, ... }:

{
  imports = [ 
    ./plasma.nix
    ./gnome.nix
  ];

  plasma.enable = lib.mkDefault true;
  plasma.forceX11 = lib.mkDefault false;

}