import { App, Astal, Gdk, Gtk } from "astal/gtk3"
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
      const command = `app2unit -s a -- ${executable}`;

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
      className="Launcher item"
      onClicked={() => { 
        hide(); 
        launchAppWithPrefix(app)
      }}
    >
      <box>
        <icon
          icon={app.iconName}
          className="Launcher item-icon"
        />
        <box valign={Gtk.Align.CENTER} vertical>
          <label
            className="Launcher item-name"
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
  const list = text(text => apps.fuzzy_query(text).slice(0, MAX_ITEMS))
  const onEnter = () => {
    apps.fuzzy_query(text.get())?.[0].launch()
    hide()
  }

  let searchRef;

  return <window
    visible={false}
    name="launcher"
    anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.BOTTOM}
    exclusivity={Astal.Exclusivity.IGNORE}
    keymode={Astal.Keymode.ON_DEMAND}
    application={App}
    onShow={(self) => {
      text.set("")
      width.set(self.get_current_monitor().workarea.width)
      
      if (searchRef) {
        searchRef.grab_focus();
      }

    }}
    onKeyPressEvent={function (self, event) {
      if (event.get_keyval()[1] === Gdk.KEY_Escape)
        self.hide()
    }}>
    <box>
      <eventbox widthRequest={width(w => w / 2)} expand onClick={hide} />
      <box 
        hexpand={false}
        vertical
      >
        <eventbox heightRequest={100} onClick={hide} />
        <box widthRequest={500} className="Launcher box" vertical>
          <entry
            setup={self => {
              searchRef = self;
            }}
            name="launcher-search"
            placeholderText="Search"
            primaryIconName="system-search"
            className="Launcher search"
            text={text()}
            onChanged={self => text.set(self.text)}
            onActivate={onEnter}
          />
          <box
            className="Launcher items-holder"
            spacing={12}
            vertical
          >
            {list.as(list => list.map(app => (
              <LauncherItem app={app} />
            )))}
          </box>
          <box
            halign={CENTER}
            className="Launcher not-found"
            vertical
            visible={list.as(l => l.length === 0)}
          >
            <icon icon="system-search-symbolic" />
            <label label="No match found" />
          </box>
        </box>
        <eventbox expand onClick={hide} />
      </box>
      <eventbox widthRequest={width(w => w / 2)} expand onClick={hide} />
    </box>
  </window>
}