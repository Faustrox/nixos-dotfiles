import { App, Astal, Gtk } from "astal/gtk4"
import { bind } from "astal"
import Tray from "gi://AstalTray"

import { open_systray } from '../variables'

export default function SysTray(monitor = 1) {
  const { BOTTOM, RIGHT } = Astal.WindowAnchor
  
  const tray = Tray.get_default()
  const isTrayVisible = bind(open_systray).as((value) => value)

  // const itemS = tray.get_items();

  return (
    <window
      visible={true}
      monitor={monitor}
      anchor={BOTTOM | RIGHT}
      application={App}
    >
      <revealer
        revealChild={isTrayVisible}
        transitionType={Gtk.RevealerTransitionType.CROSSFADE}
      >
        <centerbox>
          <box 
            cssClasses={["Tray", "corner", "left"]}
            valign={Gtk.Align.START}
          />
          <box 
            halign={Gtk.Align.CENTER} 
            cssClasses={["Tray", "box"]}
          >
            {bind(tray, "items").as(items => items.map(item => (
              <menubutton
                visible={item.gicon != null}
                cssClasses={["Tray", "app"]}
                tooltipMarkup={bind(item, "tooltip-markup")}
                menuModel={bind(item, "menu-model")}
              >
                <image gicon={bind(item, "gicon").as(value => value)} />
              </menubutton>
            )))}
          </box>
          <box 
            cssClasses={["Tray", "corner", "right"]}
            valign={Gtk.Align.START}
          />
        </centerbox>
      </revealer>
    </window>
  )
}