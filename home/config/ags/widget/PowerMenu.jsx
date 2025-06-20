import { App, Astal, Gtk, Gdk } from "astal/gtk4"
import GLib from "gi://GLib"

import { open_powermenu } from '../variables'

function PowerMenuEntry({icon, onClick}) {
  return (
    <box 
      vertical
      cssClasses={['Powermenu-entry']}
    >
      <button onClicked={onClick}>
        <label>
          {icon}
        </label>
      </button>
    </box>
  )
}

export default function PowerMenu(monitor = 0) {
  const { TOP } = Astal.WindowAnchor
  let widgetRef;

  return (
    <window
      visible={false}
      monitor={monitor}
      anchor={TOP}
      application={App}
      keymode={Astal.Keymode.ON_DEMAND}
      setup={self => {
        widgetRef = self
      }}
      onKeyPressed={(self, event) => {
        if (event === Gdk.KEY_Escape)
          open_powermenu.set(!open_powermenu.get())
      }}
    >
      <revealer
        setup={(self) => {
          open_powermenu.subscribe((value) => {
            self.revealChild = value
            widgetRef.visible = value
          })
        }}
        transitionType={Gtk.RevealerTransitionType.CROSSFADE}
      >
        <centerbox>
          <box
            cssClasses={['Powercorner', 'left']}
            valign={Gtk.Align.START}
            />
          <box 
            cssClasses={['Powermenu']}
            valign="center" 
            halign="center"
            >
            <PowerMenuEntry icon='󰐥' onClick={() => GLib.spawn_command_line_async('systemctl poweroff')} />
            <PowerMenuEntry icon='󰜉' onClick={() => GLib.spawn_command_line_async('systemctl reboot')} />
            <PowerMenuEntry icon='󰗼' onClick={() => GLib.spawn_command_line_async('uwsm stop')} />
          </box>
          <box
            cssClasses={['Powercorner', 'right']}
            valign={Gtk.Align.START}
            />
        </centerbox>
      </revealer>
    </window>
  )
}