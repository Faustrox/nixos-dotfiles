{ lib, ... }:

{
  
  imports = [
    ./gnome.nix
  ];

  dconf.setup = lib.mkDefault true;

}