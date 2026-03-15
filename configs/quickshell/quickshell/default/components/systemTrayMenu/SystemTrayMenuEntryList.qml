import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.components.systemTrayMenu
import qs.components
import qs.configs

Column {
    id: root

    required property var entries

    spacing: Spacing.sm

    Repeater {
        id: rep
        model: entries

        Loader {
            required property QsMenuEntry modelData

            Component.onCompleted: {
                setSource("./SystemTrayMenuEntry.qml", {
                    entry: Qt.binding(() => modelData),
                    width: root.width
                });
            }
        }
    }
}
