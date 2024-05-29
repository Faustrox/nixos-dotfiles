{ lib, ... }:

{
  
  imports = [
    ./git.nix
    ./kitty.nix
    ./obs.nix
    ./spicetify.nix
    ./zsh
  ];

  git.enable = lib.mkDefault true;
  
  kitty.setup = lib.mkDefault true;

  obs.enable = lib.mkDefault true;

  zsh.enable = lib.mkDefault true;
}