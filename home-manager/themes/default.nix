{ lib, ... }:

{

  imports = [
    ./dconf.nix
  ];

  dconf.setup = lib.mkDefault true;
  dconf.colorScheme = lib.mkDefault "prefer-dark";

}
