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
          src = ./scripts;
          file = "./p10k-config.sh";
        }
      ];

      shellAliases = {
        ll = "ls -l";
        nixos-switch = "nh os switch";
        nixos-boot = "nh os boot";
        nixos-switch-update = "nh os switch --update";
        nixos-boot-update = "nh os boot --update";
        nixos-clean = "nh clean all";
      };
      
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

  };

}