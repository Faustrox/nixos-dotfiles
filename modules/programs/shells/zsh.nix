{ config, pkgs, ... }:

{

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
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
        src = ./p10k-config;
        file = "./p10k.zsh";
      }
    ];
    shellAliases = {
      ll = "ls -l";
      rebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles/#the-hope";
      update = "nix flake update ~/.dotfiles";
      remove-old = "sudo nix-collect-garbage -d && sudo nixos-rebuild switch --flake ~/.dotfiles/#the-hope";
    };
  };

}