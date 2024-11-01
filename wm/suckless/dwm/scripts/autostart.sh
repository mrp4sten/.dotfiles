#!/bin/bash
# Mauricio Pasten (mavor)
# mauricio.pasten.martinez@gmail.com
feh --bg-fill ~/.dotfiles/wm/suckless/dwm/wallpapers/yone_1.jpg
dwm &
dwmblocks &
picom --config ~/.dotfiles/wm/suckless/picom/picom.conf &
