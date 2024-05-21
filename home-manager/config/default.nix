{ lib, ... }:

{
  
  imports = [
    ./zsh
    ./dconf.nix
    ./git.nix
    ./obs.nix
    ./spicetify.nix
  ];

  dconf.enable = lib.mkDefault false;

  git.enable = lib.mkDefault true;
  
  zsh.enable = lib.mkDefault true;

  obs.enable = lib.mkDefault true;

}