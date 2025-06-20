import { Astal, Gtk } from "astal/gtk4"
import { GLib } from "astal"

const isIcon = (icon) =>
    !!Astal.Icon.lookup_icon(icon)

const fileExists = (path) =>
    GLib.file_test(path, GLib.FileTest.EXISTS)

export default function Notification({ notification, onHoverLost, setup }) {
  const n = notification;
  const { START, END } = Gtk.Align
  
  return (
    <box 
      hexpand
      vertical
      setup={setup}
      // onHoverLost={onHoverLost}
    >
      <box 
        hexpand
        cssClasses={['Notification', 'info']}
      >
        {n.image && fileExists(n.image) && <box
          valign={START}
          cssClasses={['Notification', 'image']}
          css={`background-image: url("${n.image}");`}
        />}
        {n.image && isIcon(n.image) && <box
          expand={false}
          valign={START}
          cssClasses={['Notification', 'image']}
        >
          <image iconName={n.image} />
        </box>}
        <box 
          hexpand
          vertical
          css={`margin-left: 6px;`}
        >
          <box >
            {n.appName && <label
              cssClasses={['Notification', 'app']}
              halign={START}
              label={n.appName || "Unkown"}
            />}
            <button
              hexpand
              halign={END}
              cssClasses={['Notification', 'close']}
              onClicked={() => n.dismiss()}
            >
              X
            </button>
          </box>
            <label 
              wrap
              useMarkup
              cssClasses={['Notification', 'summary']}
              halign={START}
              label={n.summary}
            />
            {n.body && <label
              wrap
              useMarkup
              cssClasses={['Notification', 'body']}
              halign={START}
              label={n.body}
            />}
        </box>
        {n.get_actions().length > 0 && <box 
          cssClasses={['Notification', 'action-box']}
        >
          {n.get_actions().map(({label, id}) => (
            <button
              cssClasses={['Notification', 'action']}
              onClicked={() => n.invoke(id)}
            >
              {label}
            </button>
          ))}
        </box>}
      </box>
    </box>
  )
}

