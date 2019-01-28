{ colors }:
with colors;
''
# i3status configuration file.
# see "man i3status" for documentation.

# It is important that this file is edited as UTF-8.
# The following line should contain a sharp s:
# ß
# If the above line is not correctly displayed, fix your editor first!

general {
        colors = true
        interval = 5
        color_good = "${accent}"
        color_bad = "${mdark}"
        color_degraded = "${accent}"
}

order += "ipv6"
order += "disk /"
order += "wireless _first_"
order += "battery all"
order += "tztime local"

wireless _first_ {
        format_up = "W: (%quality at %essid) %ip"
        format_down = "W: down"
}

ethernet _first_ {
        # if you use %speed, i3status requires root privileges
        format_up = "E: %ip (%speed)"
        format_down = "E: down"
}

battery all {
        format = "%status %percentage %remaining"
}

tztime local {
        format = "%Y-%m-%d %H:%M:%S"
}

load {
        format = "%1min"
}

disk "/" {
        format = "%avail"
}
''

