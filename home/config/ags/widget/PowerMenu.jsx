import { App, Astal, Gtk } from "astal/gtk3"
import { bind, timeout } from "astal"

import { open_powermenu } from '../variables'

function PowerMenuEntry({icon, onClick}) {
  return (
    <box 
      vertical
      className='Powermenu-entry'
    >
      <button onClick={onClick}>
        <label>
          {icon}
        </label>
      </button>
    </box>
  )
}

export default function PowerMenu(monitor = 1) {
  const { TOP } = Astal.WindowAnchor
  const isMenuVisible = bind(open_powermenu).as((value) => value)

  return (
    <window
      visible={true}
      monitor={monitor}
      anchor={TOP}
      application={App}
    >
      <revealer
        revealChild={isMenuVisible}
        transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
      >
        <centerbox>
          <box
            className='Powercorner left'
            valign={Gtk.Align.START}
            />
          <box 
            className='Powermenu' 
            valign="center" 
            halign="center"
            >
            <PowerMenuEntry icon='󰐥' onClick='systemctl poweroff' />
            <PowerMenuEntry icon='󰜉' onClick='systemctl reboot' />
            <PowerMenuEntry icon='󰗼' onClick='uwsm stop' />
            <PowerMenuEntry icon='󰅖' onClick={() => open_powermenu.set(false)} />
          </box>
          <box
            className='Powercorner right'
            valign={Gtk.Align.START}
            />
        </centerbox>
      </revealer>
    </window>
  )
}