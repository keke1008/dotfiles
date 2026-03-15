pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    property var time: systemClock.date

    SystemClock {
        id: systemClock
        precision: SystemClock.Seconds
    }
}
