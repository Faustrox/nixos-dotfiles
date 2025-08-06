{ inputs, lib, pkgs, ... }:

{

  nixpkgs.overlays = [

    inputs.nix-vscode-extensions.overlays.default
    # inputs.hyprland.overlays.default

    (super: self: import ./pkgs { pkgs = self; })

    (super: self: {
      stable = import inputs.nixpkgs-stable {
        system = self.system;
        config.allowUnfree = true;
      };

      proton-em-custom = self.proton-ge-custom.overrideAttrs (oldAttrs: {
        name = "proton-em-custom";
        version = "10.0-25";

        src = super.fetchurl {
          url = "https://github.com/Etaash-mathamsetty/Proton/releases/download/EM-10.0-25/proton-EM-10.0-25.tar.xz";
          hash = "sha256-8hyjvo6EcuQrKqtydWNrK+7XG4B3XD0ZTOAfwBWzVOc=";
        };

        buildCommand =
        ''
          mkdir -p $out/bin
          tar -C $out/bin --strip=2 -x -f $src
        ''
        # Allow to keep the same name between updates
        + ''
          sed -i -r 's|"proton-.*"|"Proton-EM"|' $out/bin/compatibilitytool.vdf
        '';
      });
    })

    (super: self: {
      rtl8761b-firmware = self.rtl8761b-firmware.overrideAttrs (oldAttrs: {
        src = super.fetchFromGitHub {
          owner = "andrew-ld";
          repo = "rtl8761b-firmware";
          rev = "master";
          sha256 = "sha256-5DB7eGmKmnn2PQUHjDmKRPiNPZjC3pkSbEiE7rjdJOI=";
        };

        installPhase = ''
          install -D -pm644 \
            rtl8761b_fw.bin \
            $out/lib/firmware/rtl_bt/rtl8761b_fw.bin

          install -D -pm644 \
            rtl8761b_config.bin \
            $out/lib/firmware/rtl_bt/rtl8761b_config.bin
          
          install -D -pm644 \
            rtl8761bu_fw.bin \
            $out/lib/firmware/rtl_bt/rtl8761bu_fw.bin

          install -D -pm644 \
            rtl8761bu_config.bin \
            $out/lib/firmware/rtl_bt/rtl8761bu_config.bin
        '';
      });
    })

  ];

}
