from libqtile import bar, layout, widget, hook, qtile
from libqtile.config import Click, Drag, DropDown, Group, Key, Match, ScratchPad, Screen
from libqtile.log_utils import logger
from libqtile.lazy import lazy
import os
import subprocess

# TODO: scratchpads

mod = "mod4"
terminal = "kitty"


@hook.subscribe.startup_once
def run_once():
    logger.info("Running once")
    launches = [
        # os.path.expanduser('~/.config/qtile/autostart.sh'),
        os.path.expanduser("~/.config/qtile/wallpaper-changer.sh"),
        "dunst",
        "nm-applet",
        "greenclip daemon",
        "setxkbmap eu",
    ]

    for launch in launches:
        try:
            qtile.spawn(launch)
        except Exception as e:
            logger.error(msg=e)


@hook.subscribe.client_new
def set_floating_center(client):
    if "pavucontrol" in client.get_wm_class():
        client.set_size_floating(900, 600)
        client.center()

    if client.name:
        if "yad-calendar" in client.name:
            client.set_size_floating(250, 200)


keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "Left", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "Right", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "Up", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "Down", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"],
        "Left",
        lazy.layout.shuffle_left(),
        desc="Move window to the left",
    ),
    Key(
        [mod, "shift"],
        "Right",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key(
        [mod, "control"],
        "Left",
        lazy.layout.grow_left(),
        desc="Grow window to the left",
    ),
    Key(
        [mod, "control"],
        "Right",
        lazy.layout.grow_right(),
        desc="Grow window to the right",
    ),
    Key([mod, "control"], "Down", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "Up", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "m", lazy.window.toggle_maximize(), desc="Maximize window"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    # app related
    Key([mod], "l", lazy.spawn("thunar"), desc="Open file browser"),
    Key([], "Print", lazy.spawn("flameshot gui"), desc="Take screenshot"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod],
        "t",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    # utility
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "shift"], "r", lazy.restart(), desc="Restart qtile"),
    Key(
        [mod, "control"],
        "q",
        lazy.spawn("~/.config/qtile/powermenu.sh"),
        desc="Shutdown menu",
    ),
    # launchers
    Key([mod], "d", lazy.spawn("rofi -show drun"), desc="Opens rofi drun launcher"),
    Key(
        [mod, "shift"],
        "p",
        lazy.spawn(
            'rofi -modi "clipboard:greenclip print" -show clipboard -run-command "{cmd}"'
        ),
        desc="Open clipboard menu",
    ),
    # multimedia
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -4%"),
        desc="Lower volume",
    ),
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +4%"),
        desc="Raise volume",
    ),
    Key(
        [],
        "XF86AudioMute",
        lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
        desc="Toggle mute",
    ),
    Key(
        [],
        "XF86AudioPlay",
        lazy.spawn("playerctl play-pause"),
        desc="Toggle play/pause",
    ),
    Key(
        [],
        "XF86AudioNext",
        lazy.spawn("playerctl next"),
        desc="Next song",
    ),
    Key(
        [],
        "XF86AudioPrev",
        lazy.spawn("playerctl previous"),
        desc="Previous song",
    ),
]


group_defs = [
    {"name": "1", "label": "", "rules": [Match(wm_class="kitty")]},
    {"name": "2", "label": "󰈹", "rules": [Match(wm_class="firefox")]},
    {"name": "3", "label": "󰒱", "rules": [Match(wm_class="slack")]},
    {"name": "4", "label": "󰝚"},
    {"name": "5", "label": "5", "rules": []},
    {"name": "6", "label": "6", "rules": []},
    {"name": "7", "label": "7", "rules": []},
    {"name": "8", "label": "8", "rules": []},
    {"name": "9", "label": "9", "rules": []},
]
group_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
group_labels = ["", "󰈹", "󰒱", "󰝚", "", "", "", "", ""]
group_matches = [
    [Match(wm_class="kitty")],
    [Match(wm_class="firefox")],
    [Match(wm_class="slack")],
    [Match(wm_class="tidal-hifi")],
    [],
    [],
    [],
    [],
    [],
]
groups = [
    Group(label=group_labels[i], name=group_names[i], matches=group_matches[i])
    for i in range(len(group_names))
]

# TODO: keep scratchpad and assign keys to it
# groups.append(
#     ScratchPad(
#         "scratchpad",
#         [DropDown("volume", "pavucontrol")]
#     )
# )

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )


layout_options = {
    "border_width": 2,
    "border_single": False,
    "border_focus": "#83a598",
    "border_normal": "#a89984",
    "margin": 5,
    "single_border_width": 2,
    "border_on_single": True,
}
layouts = [
    layout.MonadTall(**layout_options),
    layout.Tile(**layout_options),
    layout.Columns(**layout_options),
    layout.Max(**layout_options),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="IBM Plex Mono, Symbols Nerd Font",
    fontsize=15,
    padding=3,
    foreground="#32302f",
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            background="#32302f",
            opacity=1,
            widgets=[
                # left
                widget.Spacer(length=10),
                widget.Image(
                    filename=os.path.expanduser("~/.config/qtile/logo.png"),
                    margin=3,
                    mouse_callbacks={
                        "Button1": lazy.spawn("rofi -show drun")
                    }
                ),
                widget.Spacer(length=5),
                widget.CurrentLayout(
                    background="#928374", padding=5, foreground="#ebdbb2", opacity=1
                ),
                widget.WindowName(
                    max_chars=60,
                    padding=5,
                    background="#0d3138",
                    foreground="#ebdbb2",
                    width=400,
                    scroll=True,
                    scroll_repeat=True,
                    empty_group_string="",
                ),
                widget.Spacer(),
                # center
                widget.GroupBox(
                    highlight_method="block",
                    active="#ebdbb2",
                    inactive="#a89984",
                    this_current_screen_border="#ebdbb2",
                    block_highlight_text_color="#504945",
                    padding_x=5,
                    padding_y=4,
                    spacing=5,
                    rounded=True,
                    use_mouse_wheel=False,
                    urgent_alert_method="block",
                    # urgent_border="#d75f5f",
                    urgent_text="#fb4934",
                    background="#32302f",
                ),
                widget.Spacer(),
                # right
                # sys tray
                widget.Systray(background="#504945", padding=2),
                widget.Spacer(length=2),
                # time
                widget.Clock(
                    format="%H:%M",
                    background="#fe8019",
                    foreground="#32302f",
                    padding=10,
                ),
                widget.Spacer(length=2),
                # date
                widget.Clock(
                    format="%a %d %b of %G",
                    background="#7daea3",
                    padding=10,
                    mouse_callbacks={
                        "Button1": lazy.spawn("/home/julian/.config/qtile/calendar.sh"),
                        "Button2": lazy.spawn("kitty -- calcurse"),
                    },
                ),
                widget.Spacer(length=2),
                # volume
                widget.PulseVolume(
                    background="#fabd2f",
                    padding=5,
                    mouse_callbacks={"Button2": lazy.spawn("pavucontrol")},
                ),
                widget.Spacer(length=2),
                # cpu
                widget.CPU(
                    format="{load_percent} ",
                    background="#b8bb26",
                    padding=5,
                    mouse_callbacks={"Button1": lazy.spawn("kitty -- btop")},
                ),
                widget.Spacer(length=2),
                # memory
                widget.Memory(
                    format="{MemPercent}% ", background="#89b482", padding=5
                ),
                widget.Spacer(length=2),
                # kbd
                widget.KeyboardLayout(
                    background="#d3869b",
                    padding=5,
                    configured_keyboards=["eu", "us"],
                ),
                widget.Spacer(length=2),
                # shutdown button
                widget.TextBox(
                    text="⏻",
                    background="#ea6962",
                    padding=5,
                    mouse_callbacks={
                        "Button1": lazy.spawn("/home/julian/.config/qtile/powermenu.sh")
                    },
                ),
                widget.Spacer(length=10),
            ],
            size=24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
        wallpaper="~/.config/wallpapers/wallhaven-1p526w_1920x1080.png",
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    border_width=1,
    border_focus="#83a598",
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class="pavucontrol"),
        Match(title="yad-calendar"),
    ],
    no_reposition_rules=[Match(title="yad-calendar")],
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.

wmname = "LG3D"
