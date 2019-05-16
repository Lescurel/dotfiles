{colors}:
with colors;
''
;=====================================================
;
; To learn more about how to configure Polybar
; go to https://github.com/jaagr/polybar
;
; The README contains alot of information
;
;=====================================================


[bar/mybar]
width = 100%
height = 26
offset-x = 0%
offset-y = 0%
fixed-center = true

background = ${dark}
foreground = ${blue}

;line-size = 3
;line-color = #f00

border-size = 0
border-color = ${dblue} 

module-margin-left = 2%
module-margin-right = 2%

with colors;
font-0 = Iosevka Mono:pixelsize=12;3
font-1 = Hack:pixelsize=10;1
font-2 = Unifont:fontformat=truetype:size=8:antialias=false;0
font-3 = Siji:pixelsize=10;1
font-4 = Font Awesome 5:pixelsize=10;1

modules-left = date
modules-center = bspwm
modules-right = backlight-acpi volume wlan battery

tray-position = none
tray-padding = 2
tray-transparent = false
tray-background = ${magenta}

;wm-restack = bspwm
;wm-restack = i3

;override-redirect = true

[module/bspwm]
type = internal/bspwm

label = %percentage:2%%
ws-icon-1 =1;□
ws-icon-2 =2;□
ws-icon-3 =3;□
ws-icon-4 =4;□
ws-icon-5 =5;□
ws-icon-6 =6;□

; icon-default = 

; format = <label-state>
label-focused = ■
label-occupied = ■
label-urgent = ■
label-empty = □

label-empty-padding = 1

label-focused-foreground = ${light}
label-focused-background = ${dblue}
label-focused-underline = ${dblue}
label-focused-padding = 1

label-urgent-foreground = ${light}
label-urgent-background = ${red}
label-urgent-underline = ${dred}
label-urgent-padding = 1

label-occupied-foreground = ${magenta}
label-occupied-background = ${dark}
label-occupied-padding = 1


[module/xbacklight]
type = internal/xbacklight

format =
label = BL

bar-width = 10
bar-indicator = |
bar-indicator-foreground = #ff
bar-indicator-font = 2
bar-fill = ─
bar-fill-font = 2
bar-fill-foreground = #9f78e1
bar-empty = ─
bar-empty-font = 2
bar-empty-foreground = ${mlight}

[module/backlight-acpi]
inherit = module/xbacklight
type = internal/backlight
card = intel_backlight

[module/cpu]
type = internal/cpu
interval = 2
format-prefix = " "
format-prefix-foreground = ${mlight}
format-underline = #f90000
label = %percentage%%

[module/memory]
type = internal/memory
interval = 2
format-prefix = " "
format-prefix-foreground = ${mlight}
format-underline = #4bffdc
label = %percentage_used%%

[module/wlan]
type = internal/network
interface = wlp2s0
interval = 3.0

format-connected =
format-connected-foreground = ${blue}
label-connected = %essid%

format-disconnected =
label-disconnected = %ifname% disconnected
label-disconnected-foreground = ${mlight}

ramp-signal-0 = 
ramp-signal-1 = 
ramp-signal-2 = 
ramp-signal-3 = 
ramp-signal-4 = 
ramp-signal-foreground = ${mlight}


[module/date]
type = internal/date
interval = 5

date =
date-alt = " %Y-%m-%d"

time = %H:%M
time-alt = %H:%M:%S

;format-prefix = 
;format-prefix-foreground = ${mlight}

label = %date% %time%

[module/pulseaudio]
type = internal/pulseaudio

; Sink to be used, if it exists (find using `pacmd list-sinks`, name field)
; If not, uses default sink
sink = alsa_output.pci-0000_12_00.3.analog-stereo

; Use PA_VOLUME_UI_MAX (~153%) if true, or PA_VOLUME_NORM (100%) if false
; Default: true
use-ui-max = true

; Interval for volume increase/decrease (in percent points) (unreleased)
; Default: 5
interval = 5


[settings]
screenchange-reload = true
;compositing-background = xor
;compositing-background = screen
;compositing-foreground = source
;compositing-border = over

;[global/wm]
;margin-top = 5
;margin-bottom = 5

[module/volume]
type = internal/alsa

format-volume = <ramp-volume> <label-volume>
# format-volume-background = #8e8e91
format-volume-padding = 3
label-volume = %percentage%%
label-volume-foreground = ${blue}

format-muted-prefix = " "
format-muted-foreground = ${blue}
label-muted = sound muted
format-muted-padding = 2

ramp-volume-0 = 
ramp-volume-1 = 
ramp-volume-2 = 

[module/battery]
type = internal/battery

; This is useful in case the battery never reports 100% charge
full-at = 99

; Use the following command to list batteries and adapters:
; $ ls -1 /sys/class/power_supply/
battery = BAT0
adapter = AC

format-charging-padding = 2
format-discharging-padding = 2
format-full-padding = 2

; If an inotify event haven't been reported in this many
; seconds, manually poll for new values.
;
; Needed as a fallback for systems that don't report events
; on sysfs/procfs.
;
; Disable polling by setting the interval to 0.
;
; Default: 5
poll-interval = 5

; see "man date" for details on how to format the time string
; NOTE: if you want to use syntax tags here you need to use %%{...}
; Default: %H:%M:%S
time-format = %H:%M

; Available tags:
;   <label-charging> (default)
;   <bar-capacity>
;   <ramp-capacity>
;   <animation-charging>
format-charging = <animation-charging> <label-charging>

; Available tags:
;   <label-discharging> (default)
;   <bar-capacity>
;   <ramp-capacity>
format-discharging = <ramp-capacity> <label-discharging>

; Available tags:
;   <label-full> (default)
;   <bar-capacity>
;   <ramp-capacity>
;format-full = <ramp-capacity> <label-full>

; Available tokens:
;   %percentage% (default)
;   %time%
;   %consumption% (shows current charge rate in watts)
label-charging = %percentage%%

; Available tokens:
;   %percentage% (default)
;   %time%
;   %consumption% (shows current discharge rate in watts)
label-discharging = %percentage%%

; Available tokens:
;   %percentage% (default)
label-full = 

; Only applies if <ramp-capacity> is used
ramp-capacity-0 = 
ramp-capacity-1 = 
ramp-capacity-2 = 
ramp-capacity-3 = 
ramp-capacity-4 = 

; Only applies if <bar-capacity> is used
bar-capacity-width = 10

; Only applies if <animation-charging> is used
animation-charging-0 = 
animation-charging-1 = 
animation-charging-2 = 
animation-charging-3 = 
animation-charging-4 = 
; Framerate in milliseconds
animation-charging-framerate = 750

''
