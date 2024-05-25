{ lib, ... }:

{
  
  imports = [
    ./zsh
    ./git.nix
    ./obs.nix
    ./spicetify.nix
  ];

  git.enable = lib.mkDefault true;
  
  zsh.enable = lib.mkDefault true;

  obs.enable = lib.mkDefault true;

}