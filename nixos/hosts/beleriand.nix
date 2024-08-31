{config, pkgs, ...}:
{
  # filesystem compression
  fileSystems = {
    "/".options = [ "subvol=root" "compress=zstd" ];
    "/home".options = [ "subvol=home" "compress=zstd" ];
    "/nix".options = [ "subvol=nix" "compress=zstd" "noatime" ];
  };

  # Hostname
  networking.hostName = "beleriand";

  # Use nvida non free packages
  hardware.nvidiaOptimus.disable = true;
  # hardware.opengl.extraPackages = [ pkgs.linuxPackages.nvidia_x11.out ];
  # hardware.opengl.extraPackages32 = [ pkgs.linuxPackages.nvidia_x11.lib32 ];
  # hardware.opengl.extraPackages32 = [ pkgs_i686.linuxPackages.nvidia_x11.out ];
  hardware.opengl.driSupport32Bit = true;

  # power management
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
        "TLP_ENABLE"=1;
        "TLP_DEFAULT_MODE"="BAT";
        "TLP_PERSISTENT_DEFAULT"=1;
        "DISK_IDLE_SECS_ON_AC"=0;
        "DISK_IDLE_SECS_ON_BAT"=2;
        "MAX_LOST_WORK_SECS_ON_AC"=15;
        "MAX_LOST_WORK_SECS_ON_BAT"=60;
        "CPU_SCALING_GOVERNOR_ON_AC"="powersave";
        "CPU_SCALING_GOVERNOR_ON_BAT"="powersave";
        "CPU_HWP_ON_AC"="default";
        "CPU_HWP_ON_BAT"="balance_power";
        "CPU_MAX_PERF_ON_AC"=100;
        "CPU_MIN_PERF_ON_BAT"=0;
        "CPU_MAX_PERF_ON_BAT"=100;
        "SCHED_POWERSAVE_ON_AC"=1;
        "SCHED_POWERSAVE_ON_BAT"=1;
        "NMI_WATCHDOG"=0;
        "ENERGY_PERF_POLICY_ON_AC"="default";
        "ENERGY_PERF_POLICY_ON_BAT"="balance-power";
        "DISK_DEVICES"="sda sdb";
        "DISK_APM_LEVEL_ON_AC"="254 254";
        "DISK_APM_LEVEL_ON_BAT"="128 128";
        "SATA_LINKPWR_ON_AC"="med_power_with_dipm max_performance";
        "SATA_LINKPWR_ON_BAT"="med_power_with_dipm min_power";
        "AHCI_RUNTIME_PM_TIMEOUT"=15;
        "PCIE_ASPM_ON_AC"="performance";
        "PCIE_ASPM_ON_BAT"="powersave";
        "RADEON_POWER_PROFILE_ON_AC"="high";
        "RADEON_POWER_PROFILE_ON_BAT"="low";
        "RADEON_DPM_STATE_ON_AC"="performance";
        "RADEON_DPM_STATE_ON_BAT"="battery";
        "RADEON_DPM_PERF_LEVEL_ON_AC"="auto";
        "RADEON_DPM_PERF_LEVEL_ON_BAT"="auto";
        "WIFI_PWR_ON_AC"="off";
        "WIFI_PWR_ON_BAT"="on";
        "SOUND_POWER_SAVE_ON_AC"=0;
        "SOUND_POWER_SAVE_ON_BAT"=0;
        "SOUND_POWER_SAVE_CONTROLLER"="Y";
        "BAY_POWEROFF_ON_AC"=0;
        "BAY_POWEROFF_ON_BAT"=0;
        "BAY_DEVICE"="sr0";
        "RUNTIME_PM_ON_AC"="on";
        "RUNTIME_PM_ON_BAT"="auto";
        "USB_AUTOSUSPEND"=1;
        "USB_BLACKLIST_BTUSB"=0;
        "USB_BLACKLIST_PHONE"=0;
        "USB_BLACKLIST_PRINTER"=1;
        "USB_BLACKLIST_WWAN"=1;
        "RESTORE_DEVICE_STATE_ON_STARTUP"=0;
    };
  };
  # hibernate when closing the lid
  services.logind.lidSwitch = "hibernate";

  # to login with fingerprint
  # services.fprintd.enable = true;
  # security.polkit = {
  #  enable = true;
  #  extraConfig = ''
  #    polkit.addRule(function (action, subject) {
  #      if (action.id == "net.reactivated.fprint.device.enroll") {
  #        return subject.user == "root" ? polkit.Result.YES : polkit.result.NO
  #     }
  #  })
  #   '';
  # };


}
