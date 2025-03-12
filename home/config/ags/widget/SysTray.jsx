import { App, Astal, Gtk } from "astal/gtk3"
import { bind } from "astal"
import Tray from "gi://AstalTray"

import { open_systray } from '../variables'

export default function SysTray(monitor = 0) {
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
        transitionType={Gtk.RevealerTransitionType.SLIDE_UP}
      >
        <centerbox>
          <box 
            className="Tray corner left"
            valign={Gtk.Align.START}
          />
          <box 
            halign={Gtk.Align.CENTER} 
            className="Tray box"
          >
            {bind(tray, "items").as(items => items.map(item => (
              <menubutton
                visible={item.gicon != null}
                className="Tray app"
                tooltipMarkup={bind(item, "tooltipMarkup")}
                usePopover={false}
                actionGroup={bind(item, "actionGroup").as(ag => ["dbusmenu", ag])}
                menuModel={bind(item, "menuModel")}
              >
                <icon gicon={bind(item, "gicon")} />
              </menubutton>
            )))}
          </box>
          <box 
            className="Tray corner right"
            valign={Gtk.Align.START}
          />
        </centerbox>
      </revealer>
    </window>
  )
}