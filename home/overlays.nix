{ config, lib, ... }:

{

  options = {
    overlays = {
      catppuccin-cursors = lib.mkEnableOption "Configure version overlays for catppuccin-cursors";
    };
  };

  # Update for fix xcursor and hyprcursor inconsistant
  config = lib.mkMerge [

    (lib.mkIf config.overlays.catppuccin-cursors {
      nixpkgs.overlays = [

        (self: super: {
          catppuccin-cursors = let

            version = "0.3.1";

          in super.catppuccin-cursors.overrideAttrs ( old: {
            inherit version; 
            
            src = super.fetchFromGitHub {
              owner = "catppuccin";
              repo = "cursors";
              rev = "v${version}";
              hash = "sha256-CuzD6O/RImFKLWzJoiUv7nlIdoXNvwwl+k5mTeVIY10=";
            };

            nativeBuildInputs = old.nativeBuildInputs ++ [ self.xcur2png ];
          });
        })
      ];
    })

  ];

}