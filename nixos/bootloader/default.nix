{ lib, ... }:

{
  imports = [
    ./grub.nix
  ];

  grub.enable = lib.mkDefault true;
}