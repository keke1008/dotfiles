import QtQuick

import qs.components
import qs.configs

Button {
    id: root

    default property Component icon
    property bool active: false
    property bool disabled: false

    property color __textColor: {
        if (root.active) {
            return Color.primary;
        } else if (root.disabled) {
            return Color.disabled;
        } else {
            return Color.foreground0;
        }
    }

    circle: true
    role: "tertiary"

    Loader {
        id: loader

        sourceComponent: root.icon

        Binding {
            target: loader.item
            property: "color"
            value: root.__textColor
        }
    }
}
