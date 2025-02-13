{ inputs, ... }: 

{

  nixpkgs.overlays = [
    inputs.nvidia-patch.overlays.default
  ];

}
