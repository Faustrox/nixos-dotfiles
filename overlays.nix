{ inputs, lib, pkgs, ... }:

{

  nixpkgs.overlays = [

    inputs.nix-vscode-extensions.overlays.default

    (super: self: import ./pkgs { pkgs = self; })

    (super: self: {
      stable = import inputs.nixpkgs-stable {
        system = self.system;
        config.allowUnfree = true;
      };
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
