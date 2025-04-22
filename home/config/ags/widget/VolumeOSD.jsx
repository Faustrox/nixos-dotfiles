import { App, Astal, Gtk } from "astal/gtk3"
import { Variable, bind, timeout } from "astal"
import Wp from "gi://AstalWp"

const audio = Wp.get_default()?.audio

function OnScreenProgress({visible}) {
  const speaker = audio.get_default_speaker()

  const iconName = Variable("")
  const value = Variable(0)

  let count = 0
  function show(v, icon) {
    visible.set(iconName.get() == "" ? false : true)
    value.set(v)
    iconName.set(icon)
    count++

    timeout(2000, () => {
      count--
      if (count === 0) visible.set(false)
    })
  }

  return (
      <revealer
        setup={(self) => {
          if (speaker) {
            self.hook(speaker, "notify::volume", () =>
              show(speaker.volume, speaker.volumeIcon),
            )
          }
        }}
        revealChild={bind(visible).as(value => value)}
        transitionType={Gtk.RevealerTransitionType.SLIDE_UP}
      >
        <centerbox>
          <box
            className="OSD corner left"
            halign={Gtk.Align.START}
          />
          <box className="OSD box">
            <box 
              hexpand
              className="OSD holder"
            >
              <box 
                className="OSD progress"
                css={bind(value).as(v => `
                  * {
                    padding-right: ${v * 17}rem;
                  }
                `)}
              >
                <icon 
                  className="OSD icon"
                  vexpand
                  halign={Gtk.Align.START}
                  // valign={Gtk.Align.CENTER}
                  icon={bind(iconName).as(value => value)} 
                />
              </box>
            </box>
          </box>
          <box
            className="OSD corner right"
            halign={Gtk.Align.START}
          />
        </centerbox>
      </revealer>
  )
}

export default function VolumeOSD(monitor = 1) {
  const { BOTTOM } = Astal.WindowAnchor
  const visible = Variable(false)

  return (
    <window
      visible={true}
      monitor={monitor}
      application={App}
      layer={Astal.Layer.OVERLAY}
      keymode={Astal.Keymode.ON_DEMAND}
      anchor={BOTTOM}
    >
      <eventbox onClick={() => visible.set(false)}>
        <OnScreenProgress visible={visible} />
      </eventbox>
    </window>
  )
}