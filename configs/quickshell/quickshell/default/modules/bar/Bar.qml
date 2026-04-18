import QtQuick
import Quickshell

import qs.configs

PanelWindow {
    id: root
    property alias screen: root.screen

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Math.max(leftArea.implicitHeight, rightArea.implicitHeight) + Spacing.sm
    color: Color.background0

    Left {
        id: leftArea

        anchors.left: parent.left
        monitorName: root.screen.name
    }

    Right {
        id: rightArea

        anchors.right: parent.right
    }
}
