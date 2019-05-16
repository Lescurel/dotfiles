{ config, lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.plugins = [ "git" "colored-man-pages" "command-not-found" "extract" "nix" ];
    ohMyZsh.customPkgs = with pkgs; [
        spaceship-prompt
        nix-zsh-completions
    ];
    ohMyZsh.theme = "spaceship";
    syntaxHighlighting.enable = true;
  };
}
