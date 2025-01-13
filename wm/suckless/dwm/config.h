/* See LICENSE file for copyright and license details. */
#include "layouts.c"
#include "selfrestart.c"
#include <X11/XF86keysym.h>
#include "exitdwm.c"
#include "fibonacci.c"

/* appearance */
static const unsigned int borderpx = 1; /* border pixel of windows */
static const unsigned int gappx = 5;    /* gaps between windows */
static const unsigned int snap = 32;    /* snap pixel */
static const unsigned int systraypinning =
    0; /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor
          X */
static const unsigned int systrayonleft =
    0;                                        /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 2; /* systray spacing */
static const int systraypinningfailfirst =
    1;                                                /* 1: if pinning fails, display systray on the first monitor, False:
                                                         display systray on the last monitor*/
static const int showsystray = 1;                     /* 0 means no systray */
static const int showbar = 1;                         /* 0 means no bar */
static const int topbar = 1; /* 0 means bottom bar */ /* 0 means bottom bar */
static const char *fonts[] = {"Hack Nerd Font Mono:size=18"};
static const char dmenufont[] = "Hack Nerd Font Mono:size=18";
static const char col_gray1[] = "#222222";
static const char col_gray2[] = "#444444";
static const char col_gray3[] = "#bbbbbb";
static const char col_gray4[] = "#eeeeee";
static const char col_cyan[] = "#005577";
/* red dark custom theme */
static const char ivory[] = "#F6F7EB";
static const char chill_red[] = "#E73D23";
static const char onyx[] = "#393E41";
static const char steel_blue[] = "#3F88C5";
static const char keepel[] = "#44BBA4";

/* Tokyo Night-inspired theme */
static const char fg[] = "#c0caf5";      // Foreground (light blue)
static const char bg[] = "#1a1b26";      // Background (very dark blue)
static const char dark_bg[] = "#15161e"; // Darker background (for contrast)
static const char cyan[] = "#7dcfff";    // Cyan
static const char blue[] = "#7aa2f7";    // Blue
static const char green[] = "#9ece6a";   // Green
static const char magenta[] = "#bb9af7"; // Magenta
static const char red[] = "#f7768e";     // Red
static const char yellow[] = "#e0af68";  // Yellow

static const char *colors[][3] = {
    /*               fg         bg         border   */
    {fg, bg, dark_bg},   /* SchemeNorm dark */
    {fg, blue, blue},    /* SchemeSel dark */
    {fg, dark_bg, cyan}, /* SchemeNorm light */
    {fg, cyan, blue},    /* SchemeSel light */
};

/* tagging */
static const char *tags[] = {"", "", "", "", "", "", "", "", ""};

static const Rule rules[] = {
    /* xprop(1):
     *	WM_CLASS(STRING) = instance, class
     *	WM_NAME(STRING) = title
     */
    /* class      instance    title       tags mask     isfloating   monitor */
    {"Gimp", NULL, NULL, 0, 1, -1},
    {"Firefox", NULL, NULL, 1 << 8, 0, -1},
};

/* layout(s) */
static const float mfact = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster = 1;    /* number of clients in master area */
static const int resizehints =
    1; /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen =
    1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
    /* symbol     arrange function */
    {"[]=", tile}, /* first entry is default */
    {"><>", NULL}, /* no layout function means floating behavior */
    {"[M]", monocle},
    {"|||", col},
    {"HHH", grid},
    {"[@]", spiral},
    {"[\\]", dwindle},
};

/* key definitions */
#define MODKEY Mod4Mask
#define AltMask Mod1Mask
#define TAGKEYS(KEY, TAG)                                          \
    {MODKEY, KEY, view, {.ui = 1 << TAG}},                         \
        {MODKEY | ControlMask, KEY, toggleview, {.ui = 1 << TAG}}, \
        {MODKEY | ShiftMask, KEY, tag, {.ui = 1 << TAG}},          \
        {MODKEY | ControlMask | ShiftMask, KEY, toggletag, {.ui = 1 << TAG}},

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd)                                           \
    {                                                        \
        .v = (const char *[]) { "/bin/sh", "-c", cmd, NULL } \
    }

/* commands */
static char dmenumon[2] =
    "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = {
    "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1,
    "-nf", onyx, "-sb", steel_blue, "-sf", col_gray4, NULL};
static const char *termcmd[] = {"kitty", NULL};
static const char *lowervolumecmd[] = {"pw-volume", "change", "-5%", NULL};
static const char *raisevolumecmd[] = {"pw-volume", "change", "+5%", NULL};
static const char *mutevolumecmd[] = {"pw-volume", "mute", "toggle", NULL};
static const char *lowerbrightnesscmd[] = {"brightnessctl", "set", "10%-",
                                           NULL};
static const char *risebrightnesscmd[] = {"brightnessctl", "set", "+10%", NULL};
static const char *lockscreen[] = {"betterlockscreen", "--lock", "blur", NULL};

static const Key keys[] = {
    /* modifier                     key        function        argument */
    {0, XF86XK_AudioLowerVolume, spawn, {.v = lowervolumecmd}},
    {0, XF86XK_AudioRaiseVolume, spawn, {.v = raisevolumecmd}},
    {0, XF86XK_AudioMute, spawn, {.v = mutevolumecmd}},
    {0, XF86XK_MonBrightnessDown, spawn, {.v = lowerbrightnesscmd}},
    {0, XF86XK_MonBrightnessUp, spawn, {.v = risebrightnesscmd}},
    {MODKEY | ShiftMask, XK_l, spawn, {.v = lockscreen}},
    {MODKEY, XK_p, spawn, {.v = dmenucmd}},
    {MODKEY | ShiftMask, XK_Return, spawn, {.v = termcmd}},
    {MODKEY, XK_b, togglebar, {0}},
    {MODKEY | ShiftMask, XK_j, rotatestack, {.i = +1}},
    {MODKEY | ShiftMask, XK_k, rotatestack, {.i = -1}},
    {MODKEY, XK_j, focusstack, {.i = +1}},
    {MODKEY, XK_k, focusstack, {.i = -1}},
    {MODKEY, XK_i, incnmaster, {.i = +1}},
    {MODKEY, XK_d, incnmaster, {.i = -1}},
    {MODKEY, XK_h, setmfact, {.f = -0.05}},
    {MODKEY, XK_l, setmfact, {.f = +0.05}},
    {MODKEY, XK_Return, zoom, {0}},
    {MODKEY, XK_Tab, view, {0}},
    {MODKEY | ShiftMask, XK_c, killclient, {0}},
    {MODKEY | AltMask, XK_1, setlayout, {.v = &layouts[0]}},
    {MODKEY | AltMask, XK_2, setlayout, {.v = &layouts[1]}},
    {MODKEY | AltMask, XK_3, setlayout, {.v = &layouts[2]}},
    {MODKEY | AltMask, XK_4, setlayout, {.v = &layouts[3]}},
    {MODKEY | AltMask, XK_5, setlayout, {.v = &layouts[4]}},
    {MODKEY | AltMask, XK_6, setlayout, {.v = &layouts[5]}},
    {MODKEY | AltMask, XK_7, setlayout, {.v = &layouts[6]}},
    {MODKEY | ControlMask, XK_comma, cyclelayout, {.i = -1}},
    {MODKEY | ControlMask, XK_period, cyclelayout, {.i = +1}},
    {MODKEY | ShiftMask, XK_space, togglefloating, {0}},
    {MODKEY, XK_0, view, {.ui = ~0}},
    {MODKEY | ShiftMask, XK_0, tag, {.ui = ~0}},
    {MODKEY, XK_comma, focusmon, {.i = -1}},
    {MODKEY, XK_period, focusmon, {.i = +1}},
    {MODKEY | ShiftMask, XK_comma, tagmon, {.i = -1}},
    {MODKEY | ShiftMask, XK_period, tagmon, {.i = +1}},
    {MODKEY | ShiftMask, XK_t, schemeToggle, {0}},
    {MODKEY | ShiftMask, XK_z, schemeCycle, {0}},
    {MODKEY, XK_minus, setgaps, {.i = -1}},
    {MODKEY, XK_equal, setgaps, {.i = +1}},
    {MODKEY | ShiftMask, XK_equal, setgaps, {.i = 0}},
    {MODKEY | ShiftMask, XK_q, quit, {0}},
    {MODKEY | ShiftMask, XK_r, self_restart, {0}},
    {MODKEY | ShiftMask, XK_e, exitdwm, {0}},
    TAGKEYS(XK_1, 0) TAGKEYS(XK_2, 1) TAGKEYS(XK_3, 2) TAGKEYS(XK_4, 3)
        TAGKEYS(XK_5, 4) TAGKEYS(XK_6, 5) TAGKEYS(XK_7, 6) TAGKEYS(XK_8, 7)
            TAGKEYS(XK_9, 8)

};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle,
 * ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
    /* click                event mask      button          function argument */
    {ClkLtSymbol, 0, Button1, setlayout, {0}},
    {ClkLtSymbol, 0, Button3, setlayout, {.v = &layouts[2]}},
    {ClkWinTitle, 0, Button2, zoom, {0}},
    {ClkStatusText, 0, Button2, spawn, {.v = termcmd}},
    {ClkClientWin, MODKEY, Button1, movemouse, {0}},
    {ClkClientWin, MODKEY, Button2, togglefloating, {0}},
    {ClkClientWin, MODKEY, Button3, resizemouse, {0}},
    {ClkTagBar, 0, Button1, view, {0}},
    {ClkTagBar, 0, Button3, toggleview, {0}},
    {ClkTagBar, MODKEY, Button1, tag, {0}},
    {ClkTagBar, MODKEY, Button3, toggletag, {0}},
    {ClkTagBar, MODKEY, Button1, tag, {0}},
    {ClkTagBar, MODKEY, Button3, toggletag, {0}},
};
