#!/usr/bin/env python3
"""
Nordic Floating Calendar — Clean GTK3 calendar popup matching dwm theme
Dismisses immediately on Escape, click-outside, or window blur.
"""
import gi, sys, os
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, Gdk

class NordicCalendar(Gtk.Window):
    def __init__(self):
        super().__init__(type=Gtk.WindowType.TOPLEVEL)
        self.set_title("nordic-calendar")
        self.set_wmclass("floatterm", "floatterm")
        self.set_decorated(False)
        self.set_resizable(False)
        self.set_position(Gtk.WindowPosition.MOUSE)
        self.set_skip_taskbar_hint(True)
        self.set_skip_pager_hint(True)
        self.set_keep_above(True)

        # Style with GTK CSS
        css = b"""
        window {
            background-color: rgba(36, 41, 51, 0.88);
            border: 2px solid #88c0d0;
            border-radius: 14px;
            padding: 12px;
        }
        calendar {
            background-color: transparent;
            color: #d8dee9;
            font-family: 'IBM Plex Sans', sans-serif;
            font-size: 13px;
        }
        calendar.header {
            color: #88c0d0;
            font-weight: bold;
        }
        calendar.button {
            color: #88c0d0;
            background-color: #2e3440;
            border-radius: 6px;
        }
        calendar:selected {
            background-color: #88c0d0;
            color: #242933;
            border-radius: 6px;
            font-weight: bold;
        }
        calendar:indeterminate {
            color: #4c566a;
        }
        calendar.highlight {
            color: #b48ead;
            font-weight: bold;
        }
        """
        style_provider = Gtk.CssProvider()
        style_provider.load_from_data(css)
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(),
            style_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

        # Main box
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        self.add(box)

        # Calendar widget
        self.cal = Gtk.Calendar()
        self.cal.set_property("show-heading", True)
        self.cal.set_property("show-day-names", True)
        self.cal.set_property("show-details", False)
        box.pack_start(self.cal, True, True, 0)

        # Events
        self.connect("key-press-event", self.on_key_press)
        self.connect("focus-out-event", self.on_focus_out)
        self.cal.connect("day-selected-double-click", lambda c: Gtk.main_quit())

    def on_key_press(self, widget, event):
        if event.keyval in (Gdk.KEY_Escape, Gdk.KEY_q):
            Gtk.main_quit()
            return True
        return False

    def on_focus_out(self, widget, event):
        Gtk.main_quit()
        return True

if __name__ == "__main__":
    # Check if another calendar instance is running; if so, toggle it closed
    import subprocess
    pid = os.getpid()
    out = subprocess.run(["pgrep", "-f", "nordic-calendar.py"], capture_output=True, text=True).stdout.split()
    other_pids = [p for p in out if p != str(pid)]
    if other_pids:
        for p in other_pids:
            try:
                os.kill(int(p), 15)
            except ProcessLookupError:
                pass
        sys.exit(0)

    win = NordicCalendar()
    win.show_all()
    Gtk.main()
