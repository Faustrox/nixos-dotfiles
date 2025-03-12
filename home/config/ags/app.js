import { App } from "astal/gtk3"
import style from "./style.scss"
import Bar from "./widget/Bar"
import PowerMenu from "./widget/PowerMenu"
import NotificationPopups from "./widget/NotificationPopups"
import SysTray from './widget/SysTray'
import Applauncher from './widget/AppLauncher'
import Calendar from './widget/Calendar'
import VolumeOSD from './widget/VolumeOSD'

App.start({
	css: style,
	main() {
		App.get_monitors().map(Bar)
		PowerMenu()
		SysTray()
		NotificationPopups()
		Applauncher()
		Calendar()
		VolumeOSD()
	},
})
