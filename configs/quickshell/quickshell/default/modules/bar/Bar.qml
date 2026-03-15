import QtQuick
import Quickshell

PanelWindow {
    id: root
    property alias screen: root.screen

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Math.max(leftArea.implicitHeight, rightArea.implicitHeight)
    color: "transparent"

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
