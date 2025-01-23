{ lib, ... }: 

{

  imports = [
    ./gaming.nix
    ./hyprclouds.nix
    ./theming.nix
  ];

  hyprclouds.enable = true;
}