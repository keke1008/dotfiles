pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Wayland

Singleton {
    id: root

    PersistentProperties {
        id: props
        reloadableId: "idleInhibitorState"

        property bool enabled: false
    }

    IdleInhibitor {
        id: idleInhibitor
        enabled: props.enabled
        window: PanelWindow {
            implicitWidth: 0
            implicitHeight: 0
            color: "transparent"
            mask: Region {}
        }
    }

    readonly property bool enabled: props.enabled
    function toggleEnabled() {
        props.enabled = !props.enabled;
    }
}
