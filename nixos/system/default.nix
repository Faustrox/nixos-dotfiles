{ lib, ... }:

{
  imports = [
    ./grub.nix
    ./main-user.nix
    ./portals.nix
  ];

  grub.enable = lib.mkDefault true;
  
}