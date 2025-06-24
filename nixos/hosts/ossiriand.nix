# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# { config, pkgs, pkgs_i686, ... }:
{ config, pkgs, ... }:
{
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # your Open GL, Vulkan and VAAPI drivers
      vpl-gpu-rt          # for newer GPUs on NixOS >24.05 or unstable
      # onevpl-intel-gpu  # for newer GPUs on NixOS <= 24.05
      # intel-media-sdk   # for older GPUs
    ];
    enable32Bit = true;
  };

  # GPU
  boot.kernelParams = [ "i915.force_probe=56a0" ];

  # v4l2
  boot.kernelModules = [ "v4l2loopback" ];

  networking.hostName = "ossiriand"; 

  # keyboard udev rules
  services.udev = {
  
    packages = with pkgs; [
      qmk-udev-rules # the only relevant
      via
    ]; # packages
  
  }; # udev
}

