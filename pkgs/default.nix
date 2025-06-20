{ pkgs, ... }:

{
  nvibrant_git = pkgs.callPackage ./nvibrant.nix { };
}