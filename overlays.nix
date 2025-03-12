{ inputs, lib, ... }:

{

  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default

    (super: self: {
      lact = self.lact.overrideAttrs (old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [ super.autoAddDriverRunpath ];
      });
    })

    (super: self: {
      proton-cachyos-custom = self.proton-ge-custom.overrideAttrs (old: {
        name = "proton-cachyos-custom";
        version = "9.0-20250307";

        src = self.fetchurl {
          url = "https://github.com/CachyOS/proton-cachyos/releases/download/cachyos-9.0-20250307-slr/proton-cachyos-9.0-20250307-slr-x86_64_v3.tar.xz";
          hash = "sha256-16KPnqbaiLWVlXCDcS50nRZhA6uUJeiCIkmVcVAvEvE=";
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
    })

  ];

}
