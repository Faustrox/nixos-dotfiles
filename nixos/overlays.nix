{ lib, config, pkgs, ... }: 

{

  options = {
    overlays = {
      gnome.setup = lib.mkEnableOption "Configure some patches for Gnome";
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