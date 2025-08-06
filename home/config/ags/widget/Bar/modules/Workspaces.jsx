import Gtk from "gi://Gtk?version=4.0"
import { createBinding, With, For } from "ags"

import Hyprland from "gi://AstalHyprland"

export default function Workspaces({ hyprMonitor }) {
  const hypr = Hyprland.get_default()
  const focusedWorkspace = createBinding(hypr, "focused-workspace")
  
  const workspaces = createBinding(hypr, "workspaces")(wss => wss
    .filter(ws => !(ws.id >= -99 && ws.id <= -2) && !(ws.monitor.get_id() != hyprMonitor.id)) // filter out special workspaces
    .sort((a, b) => a.id - b.id)
  )

  return (
      <box $type="start" class={"Workspaces"}>
        <With value={focusedWorkspace}>
          {(fw => (
            <box >
              <For each={workspaces}>
                {(ws) => (<button
                  class={`workspace ${ws.id == fw.id ? "current" : ws.clients.length && "busy"}`}
                  onClicked={() => ws.focus()}
                />
              )}
              </For>
            </box>
          ))}
        </With>
      </box>
  )
}
