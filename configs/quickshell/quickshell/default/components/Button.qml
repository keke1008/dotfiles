import Quickshell
import QtQuick

import qs.components
import qs.configs

ClickableArea {
    id: root

    default property alias data: content.sourceComponent
    property string role: "primary"

    property bool circle: false

    implicitWidth: content.width
    implicitHeight: content.height

    radius: root.circle ? root.implicitWidth / 2 : Radius.md
    border.color: Color.border
    border.width: {
        const showBorderRole = ["secondary"];
        return showBorderRole.includes(role) ? 1 : 0;
    }

    colors: {
        const map = {
            primary: Color.primary,
            secondary: Color.background1,
            tertiary: "transparent"
        };
        return {
            normal: map[role]
        };
    }

    Loader {
        id: content
        anchors.centerIn: parent
    }
}
