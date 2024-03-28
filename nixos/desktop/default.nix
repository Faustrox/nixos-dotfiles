{ lib, ... }:

{
  imports = [ 
    ./plasma.nix
    ./gnome.nix
  ];

  plasma.enable = lib.mkDefault true;

}