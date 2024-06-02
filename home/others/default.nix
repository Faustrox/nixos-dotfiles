{ lib, ... }: 

{

  imports = [
    ./gaming.nix
    ./theming.nix
  ];

  gaming.setup = lib.mkDefault true;

  theming.setup = lib.mkDefault true;
  theming.catppuccin = lib.mkDefault true;

}