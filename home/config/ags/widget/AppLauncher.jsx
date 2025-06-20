import { App, Astal, Gdk, Gtk } from "astal/gtk4"
import { Variable } from "astal"
import Apps from "gi://AstalApps"
import GLib from "gi://GLib"

const MAX_ITEMS = 8

function hide() {
    App.get_window("launcher").hide()
}

function launchAppWithPrefix(app) {
  const executable = app.get_executable();
  if (executable) {
      const command = `uwsm-app -- ${executable}`;

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
      cssClasses={["Launcher", "item"]}
      onClicked={() => { 
        hide(); 
        launchAppWithPrefix(app)
      }}
    >
      <box>
        <image
          iconName={app.iconName}
          cssClasses={["Launcher", "item-icon"]}
        />
        <box valign={Gtk.Align.CENTER} vertical>
          <label
            cssClasses={["Launcher", "item-name"]}
            truncate
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
  const apps = new Apps.Apps()
  const width = Variable(1000)

  const text = Variable("")
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
        text.set("")
        if (searchRef) {
          searchRef.grab_focus();
        }
      }}
      onKeyPressed={(self, event) => {
        if (event === Gdk.KEY_Escape)
          self.hide()
      }}
    >
    <box cssClasses={["Launcher", "container"]}>
      <box 
        hexpand={false}
        vertical
      >
        <box widthRequest={500} heightRequest={600} cssClasses={["Launcher", "box"]} vertical >
          <entry
            setup={self => {
              searchRef = self;
            }}
            name="launcher-search"
            placeholderText="Search"
            primaryIconName="system-search"
            cssClasses={["Launcher", "search"]}
            text={text.get()}
            onChanged={self => text.set(self.text)}
            onActivate={onEnter}
          />
          <box
            cssClasses={["Launcher", "items-holder"]}
            spacing={12}
            vertical
          >
            {list.as(list => list.map(app => (
              <LauncherItem app={app} />
            )))}
          </box>
          <box
            halign={CENTER}
            cssClasses={["Launcher", "not-found"]}
            vertical
            visible={list.as(l => l.length === 0)}
          >
            <image iconName="system-search-symbolic" />
            <label label="No match found" />
          </box>
        </box>
      </box>
    </box>
  </window>)
}