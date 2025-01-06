{ lib, config, pkgs, inputs, ... }: 

{

  nixpkgs.overlays = [
    inputs.hyprpanel.overlay
    inputs.nvidia-patch.overlays.default
  ];

}
