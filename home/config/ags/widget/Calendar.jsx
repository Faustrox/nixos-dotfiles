import { App, Astal, Gtk } from "astal/gtk3"
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

          return <label
            className={`Calendar ${isToday ? "day active" : isCurrentMonth ? "day" : "day unactive"}`}
            label={holderDate.getDate().toString()}
          />
        })}
      </box>
    ));
    DaysHolder.pop()
    return DaysHolder
  }

  return (
    <box vertical className="Calendar days">
      <box halign={CENTER}>
        {days.map(day => 
          <label
            className="Calendar day-indicator"
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

  const isCalendarVisible = bind(open_calendar).as((value) => value)

  return (
    <window
      visible={true}
      monitor={monitor}
      anchor={BOTTOM | LEFT}
      application={App}
    >
      <eventbox onHoverLost={open_calendar.set(false)}>
        <revealer
          revealChild={isCalendarVisible}
          transitionType={Gtk.RevealerTransitionType.SLIDE_UP}
        >
          <centerbox>
            <box vertical>
              <box 
                className="Calendar corner"
                halign={START}
              />
              <box
                className="Calendar box"
                vertical
              >
                <box vertical halign={CENTER}>
                  {/* Clock and Date Box */}
                  <box 
                    className="Calendar clock-box"
                    vertical
                  >
                    <label 
                      className="Calendar clock-time"
                      label={time()}
                    />
                    <label
                      className="Calendar clock-date"
                      label={currentDate.toLocaleDateString("en-us", { month: "long", day: "numeric" })}
                    />
                  </box>

                  {/* Calendar Box */}
                  <box className="Calendar container">
                    <CalendarBox />
                  </box>
                </box>
              </box>
            </box>
          <box 
          className="Calendar corner"
          valign={END}
          />
          </centerbox>
        </revealer>
      </eventbox>
    </window>
  )
}