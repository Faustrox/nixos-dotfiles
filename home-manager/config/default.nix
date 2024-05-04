{ lib, ... }:

{
  
  imports = [
    ./zsh
    ./dconf.nix
    ./git.nix
    ./obs.nix
    ./spicetify.nix
  ];

  dconf.enable = lib.mkDefault true;

  git.enable = lib.mkDefault true;
  
  zsh.enable = lib.mkDefault true;

  obs.enable = lib.mkDefault true;

}