{pkgs, terminal, rofi}:
let
  udiskie-helper = import ./udiskie-rofi.nix {
    inherit pkgs; rofi=rofi;
  };
in 
''
#
# wm independent hotkeys
#

# terminal emulator
super + Return
	${terminal}

super + r 
	bspc node @/ -R 90

# lock 
super + x
	dm-tool lock	

# program launcher
super + @space
	${rofi} -modi run,drun,window -lines 12 -padding 18 -width 60 -location 0 -show drun -sidebar-mode -columns 2 
	# ${rofi} -show drun	

super + w
	${rofi} -show windowcd

super + d
    ${udiskie-helper}

# polybar 
super + p 
	sh ~/.config/polybar/start.sh

# make sxhkd reload its configuration files:
super + Escape
	pkill -USR1 -x sxhkd

#
# bspwm hotkeys
#

# quit bspwm normally
super + alt + Escape
	bspc quit

# close and kill
super + {_,shift + }q
	bspc node -{c,k}

# alternate between the tiled and monocle layout
super + m
	bspc desktop -l next

# if the current node is automatic, send it to the last manual, otherwise pull the last leaf
super + y
	bspc query -N -n focused.automatic && bspc node -n last.!automatic || bspc node last.leaf -n focused

# swap the current node and the biggest node
super + g
	bspc node -s biggest

#
# state/flags
#

# set the window state
super + {t,shift + t,s,f}
	bspc node -t {tiled,pseudo_tiled,floating,fullscreen}

# set the node flags
super + ctrl + {x,y,z}
	bspc node -g {locked,sticky,private}

#
# focus/swap
#

# focus the node in the given direction
super + {_,shift + }{h,j,k,l}
	bspc node -{f,s} {west,south,north,east}

# focus the node for the given path jump
super + {p,b,comma,period}
	bspc node -f @{parent,brother,first,second}

# focus the next/previous node in the current desktop
super + {_,shift + }c
	bspc node -f {next,prev}.local

# focus the next/previous desktop in the current monitor
super + bracket{left,right}
	bspc desktop -f {prev,next}.local

# focus the last node/desktop
alt + {grave,Tab}
	bspc {node,desktop} -f last

# focus the older or newer node in the focus history
super + {o,i}
	bspc wm -h off; \
	bspc node {older,newer} -f; \
	bspc wm -h on

# focus or send to the given desktop
super + {_,shift + }{1-9,0}
	bspc {desktop -f,node -d} '^{1-9,10}'

#
# preselect
#

# preselect the direction
super + ctrl + {h,j,k,l}
	bspc node -p {west,south,north,east}

# preselect the ratio
super + ctrl + {1-9}
	bspc node -o 0.{1-9}

# cancel the preselection for the focused node
super + ctrl + space
	bspc node -p cancel
 	
# cancel the preselection for the focused desktop
super + ctrl + shift + space
	bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel

#
# move/resize
#

# expand a window by moving one of its side outward
super + alt + {h,j,k,l}
	bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}

# contract a window by moving one of its side inward
super + alt + shift + {h,j,k,l}
	bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}

# move a floating window
super + {Left,Down,Up,Right}
	bspc node -v {-20 0,0 20,0 -20,20 0}

# volume
XF86AudioRaiseVolume
	amixer set Master 1%+

# Lowers volume
XF86AudioLowerVolume
	amixer set Master 1%-

# Mutes
XF86AudioMute
#amixer set Master toggle
	amixer -D pulse set Master 1+ toggle 

# Brightness goes up
XF86MonBrightnessUp
	${pkgs.light}/bin/light -A 5

# Brightness goes down
XF86MonBrightnessDown
	${pkgs.light}/bin/light -U 5

# cycle windows 
super + Tab 
	bspc node -f next .local


''
