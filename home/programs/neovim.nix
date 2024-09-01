{ config, lib, ... }:

{

  options = {
    neovim.setup =
      lib.mkEnableOption "Enables and configure Waybar";
  };

  config = lib.mkIf config.neovim.setup {

    programs.neovim = {
      enable = true;
      vimAlias = true;
      catppuccin.enable = true;
    };

    home.sessionVariables = {
      EDITOR = "nvim";
    };

  };

}
