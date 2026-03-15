import QtQuick

import qs.components
import qs.configs

Typography {
    id: root

    readonly property list<string> __icons: ["", "", "", "", "", ""]
    property int __currentIconIndex: 0

    text: root.__icons[root.__currentIconIndex]

    Timer {
        repeat: true
        running: true
        interval: 100
        onTriggered: {
            root.__currentIconIndex = (root.__currentIconIndex + 1) % root.__icons.length;
        }
    }
}
