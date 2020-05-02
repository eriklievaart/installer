
from libqtile.command import lazy
#from libqtile import layout, bar, widget, hook
#try:
#    from libqtile.manager import Key, Group, Click, Drag, Screen
#except ImportError:
#    from libqtile.config import Key, Group, Click, Drag, Screen



from typing import List  # noqa: F401

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Screen
# from libqtile.lazy import lazy

alt = "mod1"
ctrl = "control"
shift = "shift"
mod = "mod4"

keys = [
    Key([mod], "k", lazy.layout.down(), desc="Move focus down in stack pane"),
    Key([mod], "j", lazy.layout.up(), desc="Move focus up in stack pane"),
    Key([alt], "Tab", lazy.layout.down(), desc="Move focus down in stack pane"),

    Key([mod, ctrl], "k", lazy.layout.shuffle_down(), desc="Move window down in current stack "),
    Key([mod, ctrl], "j", lazy.layout.shuffle_up(), desc="Move window up in current stack "),
    # Key([mod, shift], "k", lazy.layout.client_to_next()),

    Key([mod], "space", lazy.layout.next(), desc="Switch to other pane"),

    # Swap panes of split stack
    Key([mod, shift], "space", lazy.layout.rotate(), desc="Swap panes of split stack"),

    Key([mod, shift], "Return", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),
    Key([ctrl, alt], "t", lazy.spawn("gnome-terminal"), desc="Launch terminal"),

    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),

    Key([mod, ctrl], "r", lazy.restart(), desc="Restart qtile"),
    Key([mod, ctrl], "q", lazy.shutdown(), desc="Shutdown qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([alt], "F2", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    Key([ctrl, alt], "Left", lazy.screen.prev_group(), desc="View previous desktop"),
    Key([ctrl, alt], "Right", lazy.screen.next_group(), desc="View next desktop"),

    # move window to group = lazy.window.togroup("group_name")
    Key([ctrl, alt], "Home", lazy.screen.prev_group(), desc="Move window to next desktop"),
    Key([ctrl, alt], "End", lazy.screen.next_group(), desc="Move window to next desktop"),
]

groups = [Group(i) for i in "12345678"]

for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen(), desc="Switch to desktop {}".format(i.name)),
        Key([ctrl], "F" + i.name, lazy.group[i.name].toscreen(), desc="Switch to desktop {}".format(i.name)),
        Key([ctrl, shift], "F" + i.name, lazy.window.togroup(i.name, switch_group=True), desc="Move window to desktop {}".format(i.name)),
    ])

layouts = [
    layout.VerticalTile(),
    layout.Stack(num_stacks=2, border_focus="#FF0000", border_width=1, margin=5),
    layout.TreeTab(),

    # Try more layouts by unleashing below layouts.
    # layout.Bsp(),
    # layout.Columns(),
    # layout.Matrix(),
    # layout.Max(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font='sans',
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Systray(),
                widget.Clock(format='%a %d-%m-%Y %I:%M:%S')
            ],
            24,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"
wmname = "LG3D" # required by JAVA


