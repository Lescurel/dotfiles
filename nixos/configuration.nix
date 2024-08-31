{config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./common.nix
      ./hosts/beleriand.nix
      <home-manager/nixos>
      ./zsh.nix
      ./direnv.nix
      ./users/beren.nix
    ];

}
