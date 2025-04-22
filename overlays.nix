{ inputs, lib, pkgs, ... }:

{

  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default

    (super: self: {
      proton-cachyos-custom = self.proton-ge-custom.overrideAttrs (old: {
        name = "proton-cachyos-custom";
        version = "9.0-20250402";

        src = self.fetchurl {
          url = "https://github.com/CachyOS/proton-cachyos/releases/download/cachyos-9.0-20250402-slr/proton-cachyos-9.0-20250402-slr-x86_64_v3.tar.xz";
          hash = "sha256-DhE/EKJIyLdskcBp6L8W0KFzz3j+fZIjDrKRakABR8c=";
        };

        buildCommand = let 
        
          protonGeTitle = "Proton-CachyOS";

        in ''
          mkdir -p $out/bin
          tar -C $out/bin --strip=1 -x -f $src
        ''
        # Allow to keep the same name between updates
        + lib.strings.optionalString (protonGeTitle != null) ''
          sed -i -r 's|"proton-cachyos.*"|"${protonGeTitle}"|' $out/bin/compatibilitytool.vdf
        '';
      });
      
      proton-xiv = self.proton-ge-custom.overrideAttrs (old: {
        name = "proton-xiv";
        version = "9-26.1";

        src = self.fetchurl {
          url = "https://github.com/rankynbass/proton-xiv/releases/download/XIV-Proton9-26.1/XIV-Proton9-26.1-ntsync.tar.xz";
          hash = "sha256-9Ripy1XrZF9p2cwutWgq672EvsRp67DgCfjpGBc3ml0=";
        };

        buildCommand = let 
        
          protonGeTitle = "Proton-XIV";

        in ''
          mkdir -p $out/bin
          tar -C $out/bin --strip=1 -x -f $src
        ''
        # Allow to keep the same name between updates
        + lib.strings.optionalString (protonGeTitle != null) ''
          sed -i -r 's|"proton-cachyos.*"|"${protonGeTitle}"|' $out/bin/compatibilitytool.vdf
        '';
      });
    })

  ];

}
