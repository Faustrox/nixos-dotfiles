import { bind } from "astal"

import Hyprland from "gi://AstalHyprland"

export default function Workspaces({ hyprMonitor }) {
  const hypr = Hyprland.get_default()
  
  const workspaces = bind(hypr, "workspaces").as(wss => wss
    .filter(ws => !(ws.id >= -99 && ws.id <= -2) && !(ws.monitor.get_id() != hyprMonitor.id)) // filter out special workspaces
    .sort((a, b) => a.id - b.id)
    .map(ws => {
      const workspaceClasses = bind(hypr, "focused-workspace").as(fw => (
        ["workspace", ws.id === fw.id ? "current" : ws.clients.length > 0 ? "busy" : ""]
      ))

      return (
        <button
          cssClasses={workspaceClasses}
          onClicked={() => ws.focus()}
        />
      )
    })
  )

  return (
      <centerbox>
        <box 
          cssClasses={["Workspaces"]}
          hexpand
        >
          {workspaces}
        </box>
      </centerbox>
  )
}
