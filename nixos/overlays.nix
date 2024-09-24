{ lib, config, pkgs, ... }: 

{

  options = {
    overlays = {
      gnome.setup = lib.mkEnableOption "Configure some patches overlays for Gnome";
      proton-pass.update = lib.mkEnableOption "update proton-pass to 1.22.2";
      xone.fixes = lib.mkEnableOption "Fix xone for linux 6.11";
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

    (lib.mkIf config.overlays.xone.fixes {
      nixpkgs.overlays = [
        (self: super: {
          linuxPackages_cachyos-lto = super.linuxPackages_cachyos.extend ( selfLinux: superLinux: {
            xone = super.linuxPackages_cachyos.xone.overrideAttrs ( old: {
              patches = [
                (super.fetchpatch {
                  name = "kernel-6.11.patch";
                  url = "https://github.com/medusalix/xone/commit/28df566c38e0ee500fd5f74643fc35f21a4ff696.patch";
                  hash = "sha256-X14oZmxqqZJoBZxPXGZ9R8BAugx/hkSOgXlGwR5QCm8=";
                })
              ];
            });
          });
        })
      ];
    })

  ];

}