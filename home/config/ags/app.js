import { App } from "astal/gtk3"
import style from "./style.scss"
import Bar from "./widget/Bar"
import PowerMenu from "./widget/PowerMenu"
import NotificationPopups from "./widget/NotificationPopups"

App.start({
    css: style,
    main() {
        App.get_monitors().map(Bar)
        PowerMenu(1)
        NotificationPopups(0)
    },
})
