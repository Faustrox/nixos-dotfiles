import App from "ags/gtk4/app"
import Astal from "gi://Astal"
import Gtk from "gi://Gtk"
import Gdk from "gi://Gdk"
import GLib from "gi://GLib"

export default function RecorderStatus(monitor = 1) {
  const { TOP, RIGHT } = Astal.WindowAnchor

  return (
    <window
      visible={false}
      name="recorder"
      cssClasses={["Recorder"]}
      monitor={monitor}
      anchor={TOP | RIGHT}
      application={App}
    >
      <button
        onClicked={() => {
          GLib.spawn_command_line_async("killall -SIGINT gpu-screen-recorder")
          GLib.spawn_command_line_async("ags toggle recorder") //! Need to fix this
        }}
      >
        <label>󰑊</label>
      </button>
    </window>
  )
}