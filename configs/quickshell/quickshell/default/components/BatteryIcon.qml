import QtQuick

import qs.components
import qs.configs

PhasedIcon {
    id: root

    property alias value: root.value
    property bool charging: false
    property real warningThreshold: 0.2
    property real criticalThreshold: 0.1

    icons: {
        if (charging) {
            return ["󰂄"];
        } else {
            return ["󰂃", "󰂃", "󰁻", "󰁼", "󰁽", "󰁿", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"];
        }
    }
    color: {
        if (charging) {
            return Color.primary;
        } else if (criticalThreshold && value <= criticalThreshold) {
            return Color.error;
        } else if (warningThreshold && value <= warningThreshold) {
            return Color.warning;
        } else {
            return Color.foreground0;
        }
    }
}
