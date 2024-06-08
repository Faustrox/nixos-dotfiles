{ pkgs, lib, inputs, ... }:
let
  spicetifyPkgs = inputs.spicetify-nix.packages.x86_64-linux.default;
in
{
  # allow spotify to be installed if you don't have unfree enabled already
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify"
  ];

  # import the flake's module for your system
  imports = [ inputs.spicetify-nix.homeManagerModule ];

  # configure spicetify :)
  programs.spicetify =
    {
      enable = true;
      theme = spicetifyPkgs.themes.catppuccin;
      colorScheme = "mocha";

      enabledExtensions = with spicetifyPkgs.extensions; [
        fullAppDisplay
        shuffle # shuffle+ (special characters are sanitized out of ext names)
        hidePodcasts
        brokenAdblock
      ];
    };
}