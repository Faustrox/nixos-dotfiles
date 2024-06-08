{ config, lib, pkgs, ... }:

{

  options = {
    zsh.setup = 
      lib.mkEnableOption "Enables and configure zsh";
  };

  config = lib.mkIf config.zsh.setup {

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };

      plugins = [
        { 
          name = "powerlevel10k"; 
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = ../scripts;
          file = "./p10k-config.zsh";
        }
      ];

      shellAliases = {
        ll = "ls -l";
        nix-switch = "nh os switch";
        nix-boot = "nh os boot";
        nix-switch-update = "nh os switch --update";
        nix-boot-update = "nh os boot --update";
        nix-clean = "nh clean all";
        dayz-launch = "/home/faustrox/.scripts/dayz-launcher.sh";
        bdiscord-install = "nix run nixpkgs#betterdiscordctl install";
      };
      
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

  };

}