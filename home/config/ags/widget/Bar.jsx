import { App, Astal, Gtk } from "astal/gtk4"
import { execAsync } from "astal/process"
import { Variable, GLib, bind } from "astal"
import Hyprland from "gi://AstalHyprland"
import AstalWp from "gi://AstalWp"

import Workspaces from './Bar/Workspaces'

import { getMonitorName } from '../utils'
import { open_powermenu, open_calendar } from '../variables'

const hypr = Hyprland.get_default()

function PowerButton() {

	return (
		<button
			cssClasses={['Power']}
			onClicked={() => open_powermenu.set(!open_powermenu.get())}
		>
			<label>⏻</label>
		</button>
	)
}

function VolumeIndicator() {

	const speaker = AstalWp.get_default()?.defaultSpeaker
	const volumeIcon = bind(speaker, "volume-icon").as(value => value)

	return (
		<button
			onClicked={() => GLib.spawn_command_line_async("uwsm-app -s b -- pavucontrol")}
			cssClasses={['Button']}
		>
			<image iconName={volumeIcon}/>
		</button>
	)
}

// function SysTrayButton() {

// 	return (
// 		<button 
// 			cssClasses={["Button" ]}
// 			onClicked={() => open_systray.set(!open_systray.get())}
// 		>
// 			
// 		</button>
// 	)
// }

function Avatar() {

	return (
		<button 
			cssClasses={["Avatar"]}
			onClicked={() => GLib.spawn_command_line_async("echo 'New launcher c:'")}
		>
			<box />
		</button>
	)
}

function Clock({ format = "%I:%M %p" }) {
	const time = Variable("").poll(1000, () => GLib.DateTime.new_now_local().format(format))

	return (
		<button
			cssClasses={["Clock"]}
			onClicked={() => open_calendar.set(!open_calendar.get())}
			hexpand
		>
			<label
				onDestroy={() => time.drop()}
				label={bind(time)}
			/>
		</button>
	)
}

function Weather() {

	const codes = ["01d", "01n", "02d", "02n", "03d", "03n", "04d", "04n", "09d", "09n", "10d", "10n", "11d", "11n", "13d", "13n", "50d", "50n"]
	const icons = ["", "", "", "", "󰖐", "󰖐", "", "", "", "", "", "", "", "", "󰖘", "󰖘", "", ""]

	const weather = Variable({
		icon: "",
		temp: null,
		description: ""
	}).poll(60000, async () => {
		const weather = {
			token: "69c655f5c49d7a1612da1c5a0617d786",
			units: 'metric',
			lang: 'en',
			city: "Mao,DO"
		};

		try {
			const out = await execAsync(["curl", "-s", `https://api.openweathermap.org/data/2.5/weather?q=${weather.city}&appid=${weather.token}&lang=${weather.lang}&units=${weather.units}`])
		
			const data = JSON.parse(out);

			return {
				icon: icons[codes.indexOf(data.weather[0].icon)],
				temp: Math.round(data.main.temp),
				description: data.weather[0].description
			}
		} catch(err) {
			console.error(err)
		}

	})

	return (
		<button
			cssClasses={["Weather", "box"]}
			hexpand
		>
			<box>
				<label
					cssClasses={["Weather", "icon"]}
					label={bind(weather).as(value => value?.icon ?? "N/A")}
				/>
				<label
					cssClasses={["Weather", "temp"]}
					label={bind(weather).as(value => value.temp ? `${value.temp.toString()}°` : "N/A")}
				/>
			</box>
		</button>
	)
}

export default function Bar( gdkmonitor ) {
	const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor
	const monitorName = getMonitorName(gdkmonitor)
	const hyprMonitor = hypr.get_monitor_by_name(monitorName)
	const mainMonitor = hyprMonitor.id == 0; // FIX: Hyprland sometimes change monitors

	return (
		<>
			<window 
				visible
				gdkmonitor={gdkmonitor}
				exclusivity={Astal.Exclusivity.EXCLUSIVE}
				anchor={LEFT | TOP | RIGHT}
			>
				<box cssClasses={["Edge","", "topside"]}/>
			</window>
			<window 
				visible
				gdkmonitor={gdkmonitor}
				exclusivity={Astal.Exclusivity.EXCLUSIVE}
				anchor={TOP | BOTTOM | LEFT}
			>
				<box cssClasses={["Edge", "leftside"]}/>
			</window>
			<window 
				visible
				gdkmonitor={gdkmonitor}
				exclusivity={Astal.Exclusivity.EXCLUSIVE}
				anchor={TOP | BOTTOM | RIGHT}
			>
				<box cssClasses={["Edge", "rightside"]}/>
			</window>


			<window
				cssClasses={["Corner"]}
				visible
				layer={Astal.Layer.BACKGROUND}
				gdkmonitor={gdkmonitor}
				anchor={BOTTOM | LEFT}
			>
				<box cssClasses={["bottom-left"]}/>
			</window>
			<window
				cssClasses={["Corner"]}
				visible
				layer={Astal.Layer.BACKGROUND}
        gdkmonitor={gdkmonitor}
				anchor={BOTTOM | RIGHT}
			>
				<box cssClasses={["bottom-right"]}/>
			</window>
			<window
				cssClasses={["Corner"]}
				visible
        layer={Astal.Layer.BACKGROUND}
				gdkmonitor={gdkmonitor}
				anchor={TOP | LEFT}
			>
				<box cssClasses={["top-left"]}/>
			</window>
			<window
				cssClasses={["Corner"]}
				visible
				layer={Astal.Layer.BACKGROUND}
        gdkmonitor={gdkmonitor}
				anchor={TOP | RIGHT}
			>
				<box cssClasses={["top-right"]}/>
			</window>


			<window
				visible
				name="Bar"
				cssClasses={["Bar"]}
				gdkmonitor={gdkmonitor}
				exclusivity={Astal.Exclusivity.EXCLUSIVE}
				anchor={LEFT | BOTTOM | RIGHT}
				application={App}
			>
				<centerbox>
					<box
						halign={Gtk.Align.START}
					>
						{!mainMonitor && <Avatar/>}
						<Clock />
						{!mainMonitor && <Weather/>}
					</box>
					<box>
						<Workspaces hyprMonitor={hyprMonitor}/>
					</box>
					<box
						halign={Gtk.Align.END}
					>
						{!mainMonitor && <VolumeIndicator />}
						{/* {!mainMonitor && <SysTrayButton />} */}
						{mainMonitor && <PowerButton />}
					</box>
				</centerbox>
			</window>
		</>
	);
}
