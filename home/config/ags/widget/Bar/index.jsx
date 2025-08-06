import App from "ags/gtk4/app"
import GLib from "gi://GLib"
import Astal from "gi://Astal?version=4.0"
import Gtk from "gi://Gtk?version=4.0"
import AstalWp from "gi://AstalWp"
import Hyprland from "gi://AstalHyprland"
import { execAsync } from "ags/process"
import { createBinding } from "ags"
import { createPoll } from "ags/time"

import Workspaces from './modules/Workspaces'

import { getMonitorName } from '../../utils'
import { setPowerMenu, setCalendar } from '../../variables'

const hypr = Hyprland.get_default()

function PowerButton() {

	return (
		<button
			class={'Power'}
			onClicked={() => setPowerMenu((prev) => !prev)}
		>
			<label label="⏻"/>
		</button>
	)
}

function VolumeIndicator() {

	const speaker = AstalWp.get_default()?.defaultSpeaker
	const volumeIcon = createBinding(speaker, "volume-icon")

	return (
		<button
			onClicked={() => GLib.spawn_command_line_async("app2unit -s b -t scope -- pavucontrol")}
			class={'Button'}
		>
			<image iconName={volumeIcon(icon => icon)}/>
		</button>
	)
}

// function SysTrayButton() {

// 	return (
// 		<button 
// 			class={["Button" ]}
// 			onClicked={() => open_systray.set(!open_systray.get())}
// 		>
// 			
// 		</button>
// 	)
// }

function Avatar() {

	return (
		<button 
			class={"Avatar"}
			onClicked={() => GLib.spawn_command_line_async("echo 'New launcher c:'")}
		>
			<box />
		</button>
	)
}

function Clock({ format = "%I:%M %p" }) {
	const time = createPoll("", 1000, () => GLib.DateTime.new_now_local().format(format))

	return (
		<button
			class={"Clock"}
			onClicked={() => setCalendar((prev) => !prev)}
			hexpand
		>
			<label
				label={time}
			/>
		</button>
	)
}

function Weather() {

	const codes = [
		"01d", "01n", "02d", "02n", "03d", "03n",
		"04d", "04n", "09d", "09n", "10d", "10n",
		"11d", "11n", "13d", "13n", "50d", "50n"
	]
	
	const icons = [
		"", // 01d - Sun
		"", // 01n - Moon
		"", // 02d - Few clouds (day)
		"", // 02n - Few clouds (night)
		"󰖕", // 03d - Scattered clouds
		"󰼱", // 03n - Scattered clouds
		"", // 04d - Overcast
		"", // 04n - Overcast
		"", // 09d - Light rain
		"", // 09n - Light rain
		"", // 10d - Rain
		"", // 10n - Rain (night)
		"", // 11d - Thunderstorm
		"", // 11n - Thunderstorm
		"", // 13d - Snow
		"", // 13n - Snow
		"", // 50d - Fog
		""  // 50n - Fog
	]

	const weather = createPoll(0, 60000, async () => {
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
			class={"Weather box"}
			hexpand
		>
			<box>
				<label
					class={"Weather icon"}
					label={weather(value => value?.icon ?? "N/A")}
				/>
				<label
					class={"Weather temp"}
					label={weather(value => value.temp ? `${value.temp.toString()}°` : "N/A")}
				/>
			</box>
		</button>
	)
}

export default function Bar( gdkmonitor ) {
	const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor
	const monitorName = getMonitorName(gdkmonitor)
	const hyprMonitor = hypr.get_monitor_by_name(monitorName)
	const mainMonitor = hyprMonitor.id == 1;

	return (
		<>
			<window 
				visible
				gdkmonitor={gdkmonitor}
				exclusivity={Astal.Exclusivity.EXCLUSIVE}
				anchor={LEFT | TOP | RIGHT}
			>
				<box class={"Edge topside"}/>
			</window>
			<window 
				visible
				gdkmonitor={gdkmonitor}
				exclusivity={Astal.Exclusivity.EXCLUSIVE}
				anchor={TOP | BOTTOM | LEFT}
			>
				<box class={"Edge leftside"}/>
			</window>
			<window 
				visible
				gdkmonitor={gdkmonitor}
				exclusivity={Astal.Exclusivity.EXCLUSIVE}
				anchor={TOP | BOTTOM | RIGHT}
			>
				<box class={"Edge rightside"}/>
			</window>


			<window
				class={"Corner"}
				visible
				layer={Astal.Layer.BACKGROUND}
				gdkmonitor={gdkmonitor}
				anchor={BOTTOM | LEFT}
			>
				<box class={"bottom-left"}/>
			</window>
			<window
				class={"Corner"}
				visible
				layer={Astal.Layer.BACKGROUND}
        gdkmonitor={gdkmonitor}
				anchor={BOTTOM | RIGHT}
			>
				<box class={"bottom-right"}/>
			</window>
			<window
				class={"Corner"}
				visible
        layer={Astal.Layer.BACKGROUND}
				gdkmonitor={gdkmonitor}
				anchor={TOP | LEFT}
			>
				<box class={"top-left"}/>
			</window>
			<window
				class={"Corner"}
				visible
				layer={Astal.Layer.BACKGROUND}
        gdkmonitor={gdkmonitor}
				anchor={TOP | RIGHT}
			>
				<box class={"top-right"}/>
			</window>

			<window
				visible
				name="Bar"
				class={"Bar"}
				gdkmonitor={gdkmonitor}
				exclusivity={Astal.Exclusivity.EXCLUSIVE}
				anchor={LEFT | BOTTOM | RIGHT}
				application={App}
			>
				<centerbox>
					<box
						halign={Gtk.Align.START}
						$type="start"
					>
						{!mainMonitor && <Avatar/>}
						<Clock />
						{!mainMonitor && <Weather/>}
					</box>
					<box $type="center">
						<Workspaces hyprMonitor={hyprMonitor}/>
					</box>
					<box
						halign={Gtk.Align.END}
						$type="end"
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
