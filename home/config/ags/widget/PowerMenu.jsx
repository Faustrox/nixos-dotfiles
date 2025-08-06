import App from "ags/gtk4/app"
import GLib from "gi://GLib"
import Astal from "gi://Astal?version=4.0"
import Gtk from "gi://Gtk?version=4.0"
import Gdk from "gi://Gdk?version=4.0"

import { powerMenu, setPowerMenu } from '../variables'

function PowerMenuEntry({icon, onClick}) {
  return (
    <box 
      orientation={Gtk.Orientation.VERTICAL}
      class={'Powermenu-entry'}
    >
      <button onClicked={onClick}>
        <label label={icon} />
      </button>
    </box>
  )
}

export default function PowerMenu(monitor = 1) {
  const { TOP } = Astal.WindowAnchor
  let widgetRef;

  return (
    <window
      visible={powerMenu}
      monitor={monitor}
      anchor={TOP}
      application={App}
      keymode={Astal.Keymode.ON_DEMAND}
      // onKeyPressed={(self, event) => {
      //   if (event === Gdk.KEY_Escape)
      //     setPowerMenu(false)
      // }}
    >
      <revealer
        revealChild={powerMenu}
        transitionType={Gtk.RevealerTransitionType.CROSSFADE}
      >
        <centerbox>
          <box
            class={'Powercorner left'}
            valign={Gtk.Align.START}
            $type="start"
            />
          <box 
            class={'Powermenu'}
            valign="center" 
            halign="center"
            $type="center"
            >
            <PowerMenuEntry icon='󰐥' onClick={() => GLib.spawn_command_line_async('systemctl poweroff')} />
            <PowerMenuEntry icon='󰜉' onClick={() => GLib.spawn_command_line_async('systemctl reboot')} />
            <PowerMenuEntry icon='󰗼' onClick={() => GLib.spawn_command_line_async('uwsm stop')} />
          </box>
          <box
            class={'Powercorner right'}
            valign={Gtk.Align.START}
            $type="end"
            />
        </centerbox>
      </revealer>
    </window>
  )
}