# DWM customization

## Dependencies

- (Arch Linux) I use Arch linux btw so try to use any linux distro based on Arch.
- Learn about DWM here [Suckless official site](https://dwm.suckless.org/)
- You need to have a bit knowledge of `c`
- root permissions
- `gcc`

### Directories structure

```shell
suckless
├── dmenu_mavor # Launcher application with custom patches and utils. (You can change for ulauncher)
├── dunst # Notification manager
├── dwm # Desktop Environment
├── dwmblocks # Modular status bar for dwm
├── picom # Compositor for x server.
└── st_mavor # Terminal written in c (I prefer use Kitty or Alacritty)
```

## Installation

> You should clone this repository. Our root directory is suckless and consider that I don't show you how to configure, I'll just show you how can you copy my own config of dwm.

### DWM

1. Enter into `dwm` directory
2. Execute: `sudo make clean install`
3. Now you have installed dwm

#### DWM directory structure

```shell
dwm
├── config.def.h # If you want to modify any configuration or keybinds modify this file
├── config.h # This is the compiled file
├── config.mk
├── drw.c
├── drw.h
├── drw.o
├── dwm # The binary
├── dwm.1
├── dwm.c # The source code
├── dwm.o
├── dwm.png
├── exitdwm.c
├── fibonacci.c
├── layouts.c
├── LICENSE
├── Makefile
├── patches # All the patches that I use for my config
├── README
├── scripts # My custom scripts
│   ├── apply_patches.sh # If you want to apply new patches
│   ├── autostart_blocking.sh
│   └── autostart.sh
├── selfrestart.c
├── transient.c
├── util.c
├── util.h
├── util.o
└── wallpapers # All my wallpapers here 
```

## dmenu

1. Enter into `dmenu_mavor` directory
2. Execute: `sudo make clean install`
3. Now you have installed dmenu

### dmenu_mavor directory structure

```shell
dmenu_mavor
├── arg.h
├── config.def.h # If you want to change config, modify this file
├── config.h
├── config.mk
├── dmenu # Binary
├── dmenu.1
├── dmenu.c # Source code
├── dmenu.o
├── dmenu_path
├── dmenu_path_desktop
├── dmenu_run
├── dmenu_run_desktop
├── drw.c
├── drw.h
├── drw.o
├── LICENSE
├── Makefile
├── Makefile.orig
├── patches # All patches that I used
├── README
├── scripts # For custom scripts
├── stest
├── stest.1
├── stest.c
├── stest.o
├── util.c
├── util.h
└── util.o
```

## dwmblocks

1. Enter into `dwmblocks` directory
2. Execute `installScriptsCommands.sh`
3. Execute: `sudo make clean install`
4. Now you have installed dwmblocks

### dwmblocks directory structure

```shell
dwmblocks
├── blocks.def.h # If you want to change config modify this file
├── blocks.h
├── dwmblocks # Binary
├── dwmblocks.c # Source code
├── installScriptsCommands.sh # To install my custom scripts
├── keyboard.conf.example
├── LICENSE
├── Makefile
├── README.md
└── scripts # My custom scripts
    ├── battery # Info about battery for laptops
    ├── brightness # To manage brightness
    ├── percentage # To get percentage of battery
    ├── volume # To manage audio
    ├── xob-brightness-js
    └── xob-pulse-py
```

## picom

> Try to follow this guide [GitHub picom](https://github.com/yshui/picom)

1. Or in arch with AUR packages just try: `yay -Sy picom`
2. Copy file `picom/picom.conf` into `/etc/xdg`
3. You already have picom configurated and installed

## Dunst

1. Install from AUR packages: `yay -Sy dunst`
2. Copy file `dunst/dunstrc` into `~/.config/dunst/dunstrc`
3. Now you should see notifications (This not have sound, for me at least)
