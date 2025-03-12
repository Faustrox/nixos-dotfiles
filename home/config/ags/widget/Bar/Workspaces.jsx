import { bind } from "astal"

import Hyprland from "gi://AstalHyprland"

export default function Workspaces({ hyprMonitor }) {
  const hypr = Hyprland.get_default()

  return (
    <eventbox
      onScroll="echo 'Still working'"
    >
      <box 
        className="Workspaces" 
        hexpand
      >
        {bind(hypr, "workspaces").as(wss => wss
            .filter(ws => !(ws.id >= -99 && ws.id <= -2) && !(ws.monitor.get_id() != hyprMonitor.id)) // filter out special workspaces
            .sort((a, b) => a.id - b.id)
            .map(ws => (
                <button
                  className={bind(hypr, "focusedWorkspace").as(fw =>
                      `workspace ${ws === fw ? "current" : ws.get_clients().length > 0 ? "busy" : ""} `)}
                  onClicked={() => ws.focus()}
                />
            ))
        )}
      </box>
    </eventbox>
  )
}