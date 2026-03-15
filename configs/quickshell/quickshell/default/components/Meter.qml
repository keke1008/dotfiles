import QtQuick
import QtQuick.Layouts

import qs.components
import qs.configs
import qs.states

Rectangle {
    id: root

    property alias fillColor: fill.color
    required property real value

    Layout.fillWidth: true
    radius: Radius.md
    border.width: 1
    border.color: Color.border

    Rectangle {
        id: fill

        width: value * (parent.width - parent.border.width * 2)
        height: parent.height - parent.border.width * 2
        anchors {
            left: parent.left
            leftMargin: parent.border.width
            verticalCenter: parent.verticalCenter
        }
        radius: parent.radius - parent.border.width * 2

        Behavior on width {
            NumberAnimation {
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }
    }
}
