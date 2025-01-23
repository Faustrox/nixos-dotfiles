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
    };
    catppuccin.nvim.enable = false;

    home.sessionVariables = {
      EDITOR = "nvim";
    };

  };

}
