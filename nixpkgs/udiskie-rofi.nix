{pkgs}:
pkgs.writeScript "udiskie-helper"
''
#!${pkgs.bash}/bin/sh

device=$(${pkgs.udiskie}/bin/udiskie-info -0 -a -o "{device_file} {ui_label}" | ${pkgs.rofi} -dmenu | cut -d' ' -f1)

if [ -n "$device" ] ; then

    if mount | grep "$device" ; then
        echo "mounted"
        ${pkgs.udisks}/bin/udisksctl unmount -b "$device"
    else
        echo "not mounted"
        ${pkgs.udisks}/bin/udisksctl mount -b "$device"
    fi
fi
''
