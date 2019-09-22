{pkgs, bar, notification, wallpaper}:
let colors = import ../colors.nix; in 
with colors;
''
#!/bin/sh

${bar} &

${pkgs.udiskie}/bin/udiskie --tray &

${pkgs.feh}/bin/feh --bg-fill ${wallpaper} &
/run/current-system/sw/bin/bspc monitor -d 1 2 3 4 5 6 

/run/current-system/sw/bin/bspc config border_width         4
/run/current-system/sw/bin/bspc config focused_border_color "${blue}"
/run/current-system/sw/bin/bspc config normal_border_color  "${dblue}" 
/run/current-system/sw/bin/bspc config window_gap           10 

/run/current-system/sw/bin/bspc config split_ratio          0.50
/run/current-system/sw/bin/bspc config borderless_monocle   true
/run/current-system/sw/bin/bspc config gapless_monocle      true 
/run/current-system/sw/bin/bspc config initial_polarity 	 second_child

/run/current-system/sw/bin/bspc config focus_follows_pointer true
  
/run/current-system/sw/bin/bspc config presel_feedback_color "${blue}"
/run/current-system/sw/bin/bspc config urgent_border_color "${red}"

${notification} &

''
