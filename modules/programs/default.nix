{ config, pkgs, ... }:

{
  
  imports = [
    ./git.nix
    ./shells/zsh.nix
  ];

}