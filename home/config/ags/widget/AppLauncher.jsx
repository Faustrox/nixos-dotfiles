import App from "ags/gtk4/app"
import GLib from "gi://GLib"
import Astal from "gi://Astal?version=4.0"
import Gtk from "gi://Gtk?version=4.0"
import Gdk from "gi://Gdk?version=4.0"
import AstalApps from "gi://AstalApps"
import { createState, For } from "ags"

const MAX_ITEMS = 8

function hide() {
    App.get_window("launcher").hide()
}

function launchAppWithPrefix(app) {
  const executable = app.get_executable();
  if (executable) {
    const command = `sh -c 'setsid app2unit -t scope -- ${executable} >/dev/null 2>&1 < /dev/null &'`;

      try {
        GLib.spawn_command_line_async(command);
      } catch (err) {
        console.error('Error while launching app:', err);
      }
  } else {
      console.error('Could not get app executable.');
  }
}

function LauncherItem({ app }) {
  return (
    <button
      class={"Launcher item"}
      onClicked={() => { 
        hide(); 
        launchAppWithPrefix(app)
      }}
    >
      <box>
        <image
          iconName={app.iconName}
          class={"Launcher item-icon"}
        />
        <box 
          valign={Gtk.Align.CENTER} 
          orientation={Gtk.Orientation.VERTICAL}
        >
          <label
            class={"Launcher item-name"}
            // truncate
            xalign={0}
            label={app.name}
          />
        </box>
      </box>
    </button>
  )
}

export default function Applauncher() {
  const { CENTER } = Gtk.Align
  const apps = new AstalApps.Apps()
  const [width, setWidth] = createState(1000)

  const [text, setText] = createState("")
  const list = text(text => (apps.fuzzy_query(text) ?? []).slice(0, MAX_ITEMS))
  const onEnter = () => {
    apps.fuzzy_query(text.get())?.[0].launch()
    hide()
  }

  let searchRef;

  return (
    <window
      visible={false}
      modal={true}
      name="launcher"
      anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.BOTTOM}
      exclusivity={Astal.Exclusivity.IGNORE}
      keymode={Astal.Keymode.ON_DEMAND}
      application={App}
      onShow={(self) => {
        setText("")
        if (searchRef) {
          searchRef.grab_focus();
        }
      }}
      // onKeyPressed={(self, event) => {
      //   if (event === Gdk.KEY_Escape)
      //     self.hide()
      // }}
    >
    <box class={"Launcher container"}>
      <box 
        hexpand={false}
        orientation={Gtk.Orientation.VERTICAL}
      >
        <box widthRequest={500} heightRequest={600} class={"Launcher box"} orientation={Gtk.Orientation.VERTICAL} >
          <entry
            $={self => {
              searchRef = self;
            }}
            name="launcher-search"
            placeholderText="Search"
            primaryIconName="system-search"
            class={"Launcher search"}
            text={text(text => text)}
            onChanged={self => setText(self.text)}
            onActivate={onEnter}
          />
          <box
            class={"Launcher items-holder"}
            spacing={12}
            orientation={Gtk.Orientation.VERTICAL}
          >
            <For each={list}>
              {(app) => <LauncherItem app={app} />}
            </For>
            {/* {list.as(list => list.map(app => (
              <LauncherItem app={app} />
            )))} */}
          </box>
          <box
            halign={CENTER}
            class={"Launcher not-found"}
            orientation={Gtk.Orientation.VERTICAL}
            visible={list(l => l.length === 0)}
          >
            <image iconName="system-search-symbolic" />
            <label label="No match found" />
          </box>
        </box>
      </box>
    </box>
  </window>)
}