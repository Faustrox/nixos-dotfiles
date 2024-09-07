{ lib, config, pkgs, ... }: 

{

  options = {
    overlays = {
      gnome.setup = lib.mkEnableOption "Configure some patches overlays for Gnome";
      proton-pass.update = lib.mkEnableOption "update proton-pass to 1.22.2";
    };
  };

  config = lib.mkMerge [

    (lib.mkIf config.overlays.gnome.setup {
      nixpkgs.overlays = [
        (self: super: {
          gnome = super.gnome.overrideScope (gnomeFinal: gnomePrev: {
            mutter = gnomePrev.mutter.overrideAttrs ( old: {
              patches = (old.patches or []) ++ [
                (super.fetchpatch { # Dynamic Tripple Buffering v4
                  url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/1441.patch";
                  hash = "sha256-kAWSSuRLmf0GHr/XET+cDUXcIcBnivRfBRfKSSGd/94=";
                })
                (super.fetchpatch { # Increase default deadline evasion to 1000 microseconds
                  url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/3373.patch";
                  hash = "sha256-EC4YcCEQD38ilZ/pHhf18kVkAd5tNZr4PzbqJxNID9Y=";
                })
              ];
            });
          });
        })
      ];
    })

    (lib.mkIf config.overlays.proton-pass.update {
      nixpkgs.overlays = [
        (self: super: {
          proton-pass = let
            
            version = "1.22.2";

          in super.proton-pass.overrideAttrs ( old: {
            inherit version;

            src = super.fetchurl {
              url = "https://proton.me/download/PassDesktop/linux/x64/ProtonPass_${version}.deb";
              hash = "sha256-aiotNWub/82YEyrveoTiRacaSoUT9Srw0s98XtXVN7g=";
            };
          });
        })
      ];
    })

  ];

}