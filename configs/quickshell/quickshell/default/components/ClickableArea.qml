import QtQuick
import QtQuick.Controls

import qs.configs
import qs.states

Rectangle {
    id: root

    implicitWidth: childrenRect.width
    implicitHeight: childrenRect.height

    default property alias data: root.data
    property bool active: true

    readonly property string state: {
        if (!root.active) {
            return "normal";
        } else if (abstractButton.pressed) {
            return "pressed";
        } else if (abstractButton.hovered) {
            return "hovered";
        } else if (abstractButton.activeFocus && [Qt.TabFocusReason, Qt.BacktabFocusReason].includes(abstractButton.focusReason)) {
            return "hovered";
        } else {
            return "normal";
        }
    }

    property var colors: ({})
    color: {
        const fallback = {
            pressed: Color.background0,
            hovered: Color.background2,
            normal: "transparent"
        };
        return root.colors[state] ?? fallback[state];
    }

    signal clicked(var e)

    AbstractButton {
        id: abstractButton
        anchors.fill: parent
        hoverEnabled: true

        onClicked: e => root.active && root.clicked?.(e)
    }
}
