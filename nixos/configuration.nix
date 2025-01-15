{config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./common.nix
      ./hosts/ossiriand.nix
      <home-manager/nixos>
      ./zsh.nix
      ./direnv.nix
      ./users/beren.nix
    ];

}
