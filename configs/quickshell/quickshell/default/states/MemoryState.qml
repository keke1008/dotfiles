pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real totalGiB: 1
    property real usedGiB: 0
    property real usage: usedGiB / totalGiB

    readonly property RefCounter refCounter: RefCounter {}

    FileView {
        id: memInfoFile
        path: "/proc/meminfo"

        onLoaded: {
            const lines = memInfoFile.text().split("\n");
            const memTotalLine = lines.find(line => line.startsWith("MemTotal:"));
            const memAvailableLine = lines.find(line => line.startsWith("MemAvailable:"));

            const parseGiB = line => {
                const parts = line.split(/\s+/);
                return parseInt(parts[1], 10) / 1024 / 1024; // Convert from kB to GiB
            };

            root.totalGiB = parseGiB(memTotalLine);
            const availableGiB = parseGiB(memAvailableLine);
            root.usedGiB = root.totalGiB - availableGiB;
        }
    }

    Timer {
        interval: 5000
        running: root.refCounter.active
        triggeredOnStart: true
        repeat: true
        onTriggered: memInfoFile.reload()
    }
}
