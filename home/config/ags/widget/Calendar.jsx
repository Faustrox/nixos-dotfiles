import { App, Astal, Gtk, Gdk } from "astal/gtk4"
import { bind, Variable, GLib } from "astal"

import { open_calendar } from '../variables'

function CalendarBox() {

  const days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  const { CENTER } = Gtk.Align;

  function GetCalendar() {

    const currentDate = new Date();
    const year = currentDate.getFullYear();
    const month = currentDate.getMonth();

    const firstDayOfMonth = new Date(year, month, 0).getDay();

    const DaysHolder = days.map((_, count) => (
      <box halign={CENTER}>
        {days.map((_, indx) => {
          const holderDate = new Date(year, month, indx + (count * 7) - firstDayOfMonth)

          const isToday = currentDate.toLocaleDateString("en-us",) == holderDate.toLocaleDateString("en-us");
          const isCurrentMonth = currentDate.getMonth() == holderDate.getMonth();

          const calendarClasses = ["Calendar", "day", isToday ? "active" : !isCurrentMonth ? "unactive" : ""]

          return <label
            cssClasses={calendarClasses}
            label={holderDate.getDate().toString()}
          />
        })}
      </box>
    ));
    DaysHolder.pop()
    return DaysHolder
  }

  return (
    <box vertical cssClasses={["Calendar", "days"]}>
      <box halign={CENTER}>
        {days.map(day => 
          <label
            cssClasses={["Calendar", "day-indicator"]}
            label={day}
          />
        )}
      </box>
      <box vertical>
        <GetCalendar />
      </box>
    </box>
  )
}

export default function Calendar(monitor = 1) {
  const { BOTTOM, LEFT } = Astal.WindowAnchor
  const { CENTER, START, END } = Gtk.Align;

  const time = Variable("").poll(1000, () => GLib.DateTime.new_now_local().format("%I:%M"))
  const currentDate = new Date();

  let widgetRef;

  return (
    <window
      visible={false}
      monitor={monitor}
      anchor={BOTTOM | LEFT}
      application={App}
      setup={self => {
        widgetRef = self
      }}
      onKeyPressed={(self, event) => {
        if (event === Gdk.KEY_Escape)
          open_calendar.set(!open_calendar.get())
      }}
    >
      {/* <box> */}
        <revealer
          transitionType={Gtk.RevealerTransitionType.CROSSFADE}
          setup={(self) => {
            open_calendar.subscribe((value) => {
              self.revealChild = value
              widgetRef.visible = value
            })
          }}
        >
          <centerbox>
            <box vertical>
              <box 
                cssClasses={["Calendar", "corner"]}
                halign={START}
              />
              <box
                cssClasses={["Calendar", "box"]}
                vertical
              >
                <box vertical halign={CENTER}>
                  {/* Clock and Date Box */}
                  <box 
                    cssClasses={["Calendar", "clock-box"]}
                    vertical
                  >
                    <label 
                      cssClasses={["Calendar", "clock-time"]}
                      label={time()}
                    />
                    <label
                      cssClasses={["Calendar", "clock-date"]}
                      label={currentDate.toLocaleDateString("en-us", { month: "long", day: "numeric" })}
                    />
                  </box>

                  {/* Calendar Box */}
                  <box cssClasses={["Calendar", "container"]}>
                    <CalendarBox />
                  </box>
                </box>
              </box>
            </box>
          <box 
            cssClasses={["Calendar", "corner"]}
            valign={END}
          />
          </centerbox>
        </revealer>
      {/* </box> */}
    </window>
  )
}