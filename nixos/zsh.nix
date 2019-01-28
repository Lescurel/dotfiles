{ config, lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.plugins = [ "git" ];
    ohMyZsh.theme = "kphoen";
    syntaxHighlighting.enable = true;
  };
}
