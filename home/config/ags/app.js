import { App } from "astal/gtk4"
import style from "./style.scss"
import Bar from "./widget/Bar"
import PowerMenu from "./widget/PowerMenu"
import Applauncher from './widget/AppLauncher'
import Calendar from './widget/Calendar'
import RecorderStatus from './widget/RecorderStatus'
// import NotificationPopups from "./widget/NotificationPopups"
// import SysTray from './widget/SysTray'
// import VolumeOSD from './widget/VolumeOSD'

App.start({
	css: style,
	main() {
		App.get_monitors().map(Bar)
		PowerMenu()
		Applauncher()
		Calendar()
		RecorderStatus()
		// NotificationPopups()
		// SysTray()
		// VolumeOSD()
	},
})
