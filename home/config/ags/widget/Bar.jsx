import { App, Astal, Gtk } from "astal/gtk3"
import { Variable, GLib } from "astal"
import Hyprland from "gi://AstalHyprland"

import Workspaces from './Bar/Workspaces'

import { getMonitorName } from '../utils'
import { open_powermenu } from '../variables'

const hypr = Hyprland.get_default()

function PowerButton({ monitor }) {
	const monitorName = getMonitorName(monitor)

	return (
		<button
			visible={hypr.get_monitor_by_name(monitorName).id == 0 ? true : false}
			className='Power'
			onClick={() => open_powermenu.set(!open_powermenu.get())}
		>
			<label>⏻</label>
		</button>
	)
}

function Indicator({ }) {

	return (
		<button 
			onClick="echo 'Here is control center'"
			className='Indicator'
		>
			<label>
				
			</label>
		</button>
	)
}

function Avatar({ monitor }) {
	const monitorName = getMonitorName(monitor)

	return (
		<button 
			visible={hypr.get_monitor_by_name(monitorName).id == 0 ? false : true}
			className="Avatar"
			onClicked="echo 'New launcher c:'"
		>
			<box />
		</button>
	)
}

function Clock({ format = "%I:%M %p" }) {
	const time = Variable("").poll(1000, () => GLib.DateTime.new_now_local().format(format))

	return (
		<button
			className="Clock"
			onClicked="echo hello"
			hexpand
		>
			<label
				onDestroy={() => time.drop()}
				label={time()}
			/>
		</button>
	)
}

export default function Bar(gdkmonitor) {
	const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor

	return (
		<>
			<window 
				visible
				gdkmonitor={gdkmonitor}
				exclusivity={Astal.Exclusivity.EXCLUSIVE}
				anchor={LEFT | TOP | RIGHT}
			>
				<box className="Edge topside"/>
			</window>
			<window 
				visible
				gdkmonitor={gdkmonitor}
				exclusivity={Astal.Exclusivity.EXCLUSIVE}
				anchor={TOP | BOTTOM | LEFT}
			>
				<box className="Edge leftside"/>
			</window>
			<window 
				visible
				gdkmonitor={gdkmonitor}
				exclusivity={Astal.Exclusivity.EXCLUSIVE}
				anchor={TOP | BOTTOM | RIGHT}
				application={App}
			>
				<box className="Edge rightside"/>
			</window>


			<window
				className="Corner"
				visible
			  layer={Astal.Layer.BACKGROUND}
				gdkmonitor={gdkmonitor}
				anchor={BOTTOM | LEFT}
			>
				<box className="bottom-left"/>
			</window>
			<window
				className="Corner"
				visible
			  layer={Astal.Layer.BACKGROUND}
        gdkmonitor={gdkmonitor}
				anchor={BOTTOM | RIGHT}
			>
				<box className="bottom-right"/>
			</window>
			<window
				className="Corner"
				visible
        layer={Astal.Layer.BACKGROUND}
				gdkmonitor={gdkmonitor}
				anchor={TOP | LEFT}
			>
				<box className="top-left"/>
			</window>
			<window
				className="Corner"
				visible
				layer={Astal.Layer.BACKGROUND}
        gdkmonitor={gdkmonitor}
				anchor={TOP | RIGHT}
			>
				<box className="top-right"/>
			</window>


			<window
				visible
				className="Bar"
				gdkmonitor={gdkmonitor}
				exclusivity={Astal.Exclusivity.EXCLUSIVE}
				anchor={LEFT | BOTTOM | RIGHT}
				application={App}
			>
				<centerbox>
					<box
						halign={Gtk.Align.START}
					>
						<Avatar monitor={gdkmonitor}/>
						<Clock />
					</box>
					<box>
						<Workspaces monitor={gdkmonitor}/>
					</box>
					<box
						halign={Gtk.Align.END}
					>
						{/* <Indicator /> */}
						<PowerButton monitor={gdkmonitor}/>
					</box>
				</centerbox>
			</window>
		</>
	);
}
