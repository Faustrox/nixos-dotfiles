import { bind } from "astal"
import { getMonitorName } from '../../utils'

import Hyprland from "gi://AstalHyprland"

export default function Workspaces({ monitor }) {
  const hypr = Hyprland.get_default()
  const monitorName = getMonitorName(monitor)

  return (
    <eventbox
      onScroll="echo 'Still working'"
    >
      <box 
        className="Workspaces" 
        hexpand
      >
        {bind(hypr, "workspaces").as(wss => wss
            .filter(ws => !(ws.id >= -99 && ws.id <= -2) && !(ws.monitor.get_name() != monitorName)) // filter out special workspaces
            .sort((a, b) => a.id - b.id)
            .map(ws => (
                <button
                  className={bind(hypr, "focusedWorkspace").as(fw =>
                      `workspace ${ws === fw ? "current" : ""}`)}
                  onClicked={() => ws.focus()}
                />
            ))
        )}
      </box>
    </eventbox>
  )
}