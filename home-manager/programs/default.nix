{ lib, ... }:

{
  
  imports = [
    ./git.nix
  ];

  git.enable = lib.mkDefault true;

}