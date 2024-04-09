{ lib, ... }:

{
  imports = [ 
    ./plasma.nix
    ./gnome.nix
  ];

  plasma.enable = lib.mkDefault true;
  plasma6.enable = lib.mkDefault false;
  plasma6.forceX11 = lib.mkDefault false;

}