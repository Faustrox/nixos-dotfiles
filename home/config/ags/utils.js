import { Gdk } from "astal/gtk4"

export function getMonitorName(gdkmonitor) {
  const display = Gdk.Display.get_default();
  const monitors = display.get_monitors();
  
  for (const monitor of monitors) {
    if(gdkmonitor == monitor) {
      return monitor.get_connector()
    }
  }
}
