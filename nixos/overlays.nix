{ lib, config, pkgs, ... }: 

{

  options = {
    overlays = {
      gnome.setup = lib.mkEnableOption "Configure some patches overlays for Gnome";
      proton-pass.update = lib.mkEnableOption "update proton-pass to 1.22.2";
      hyprland-portal.fix = lib.mkEnableOption "Fix xdg-desktop-portal-hyprland build error";
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

    (lib.mkIf config.overlays.hyprland-portal.fix {
      nixpkgs.overlays = [
        (self: super: {
          xdg-desktop-portal-hyprland = super.xdg-desktop-portal-hyprland.overrideAttrs ( old: {

            patches = [
              (super.fetchpatch {
                url = "https://github.com/hyprwm/xdg-desktop-portal-hyprland/commit/5555f467f68ce7cdf1060991c24263073b95e9da.patch";
                hash = "sha256-yNkg7GCXDPJdsE7M6J98YylnRxQWpcM5N3olix7Oc1A=";
              })
              (super.fetchpatch {
                url = "https://github.com/hyprwm/xdg-desktop-portal-hyprland/commit/0dd9af698b9386bcf25d3ea9f5017eca721831c1.patch";
                hash = "sha256-Y6eWASHoMXVN2rYJ1rs0jy2qP81/qbHsZU+6b7XNBBg=";
              })
              # handle finding wayland-scanner more nicely
              (super.fetchpatch {
                url = "https://github.com/hyprwm/xdg-desktop-portal-hyprland/commit/2425e8f541525fa7409d9f26a8ffaf92a3767251.patch";
                hash = "sha256-6dCg/U/SIjtvo07Z3tn0Hn8Xwx72nwVz6Q2cFnObonU=";
              })
            ];

            depsBuildBuild = [
              self.pkg-config
            ];

          });
        })
      ];
    })

  ];

}