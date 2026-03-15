pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import qs.states

Singleton {
    id: root

    property var __previous: undefined

    property real cpuUsage: 0
    property var cpuUsages: cpuUsageModel

    readonly property RefCounter refCounter: RefCounter {}

    ScriptModel {
        id: cpuUsageModel
        values: []
        objectProp: "name"
    }

    FileView {
        id: cpuStatFile
        path: "/proc/stat"

        onLoaded: {
            const lines = cpuStatFile.text().split("\n");
            const stats = new Map(lines.filter(line => line.startsWith("cpu")).map(line => {
                const parts = line.trim().split(/\s+/);
                const name = parts[0];
                const values = parts.slice(1).map(p => parseInt(p, 10));
                const total = values.reduce((a, b) => a + b, 0);
                const idle = values[3] + (values[4] ?? 0); // idle + iowait
                return [name,
                    {
                        total: total,
                        busy: total - idle
                    }
                ];
            }));

            if (__previous !== undefined) {
                const usages = new Map([...stats.entries()].map(([name, current]) => {
                    const previous = __previous.get(name);
                    const totalDiff = current.total - previous.total;
                    const busyDiff = current.busy - previous.busy;
                    return [name, Math.min(Math.max(busyDiff / totalDiff, 0), 1)];
                }));

                cpuUsage = usages.get("cpu") ?? 0;
                cpuUsageModel.values = [...usages.entries()].filter(([name]) => name !== "cpu").map(([name, usage]) => ({
                            name,
                            usage
                        }));
            }

            __previous = stats;
        }
    }

    FileView {
        id: cpuInfoFile
        path: "/proc/cpuinfo"

        onLoaded: {
            const lines = cpuInfoFile.text().split("\n");
            const processorLines = lines.filter(line => line.startsWith("processor"));
            cpuUsageModel.values = Array(processorLines.length).fill(undefined).map((_, i) => ({
                        name: `cpu${i}`,
                        value: 0
                    }));
        }
    }

    Timer {
        interval: 2000
        running: root.refCounter.active
        repeat: true
        onTriggered: cpuStatFile.reload()
    }

    Timer {
        interval: 500
        running: root.refCounter.active
        repeat: false
        onTriggered: cpuStatFile.reload()
    }
}
