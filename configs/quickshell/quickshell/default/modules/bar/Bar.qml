import QtQuick
import Quickshell

import qs.components
import qs.configs
import qs.states

PanelWindow {
    id: root
    property alias screen: root.screen

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: content.height
    color: ApplicationState.showDrawer ? Color.background0 : "transparent"

    Padding {
        id: content

        width: parent.width
        horizontalPadding: 0
        padding: Spacing.sm

        Left {
            anchors.left: parent.left
            monitorName: root.screen.name
        }

        Right {
            anchors.right: parent.right
        }
    }
}
