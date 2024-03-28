{ lib, ... }:

{

  imports = [
    ./network.nix
    ./time.nix
    ./x11.nix
  ];

  network.enable = lib.mkDefault true;
  time.enable = lib.mkDefault true;

  x11.enable = lib.mkDefault true;

}