{ pkgs, lib, inputs, ... }:

{
  # configure spicetify :)
  programs.spicetify =
    let
      spicetifyPkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      enable = true;
      enabledExtensions = with spicetifyPkgs.extensions; [
        fullAppDisplay
        adblock
        hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of extension names)
      ];
      theme = spicetifyPkgs.themes.catppuccin;
      colorScheme = "mocha";
    };
}
