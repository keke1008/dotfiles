import QtQuick
import QtQuick.Effects

import qs.configs

MultiEffect {
    id: root

    default property Item content
    property real radius: Radius.md

    maskEnabled: true
    maskSource: mask

    source: root.content

    implicitWidth: root.content.width
    implicitHeight: root.content.height

    Binding {
        target: root.content
        property: "parent"
        value: root
    }

    Binding {
        target: root.content.layer
        property: "enabled"
        value: true
    }

    Binding {
        target: root.content
        property: "visible"
        value: false
    }

    Rectangle {
        id: mask

        anchors.fill: parent
        radius: root.radius
        layer.enabled: true
        visible: false
    }
}
