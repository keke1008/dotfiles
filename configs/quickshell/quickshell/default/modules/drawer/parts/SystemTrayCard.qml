import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

import qs.components
import qs.configs
import qs.states

Card {
    id: root
    width: parent.width

    Column {
        width: parent.width
        spacing: Spacing.sm

        TextPadding {
            Typography {
                text: "System Tray"
                fontSize: FontSize.md
            }
        }

        HorizontalDivider {}

        Repeater {
            model: SystemTray.items

            SystemTrayMenu {
                required property SystemTrayItem modelData

                menuItem: modelData
                width: parent.width
            }
        }
    }
}
