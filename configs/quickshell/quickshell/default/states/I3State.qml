pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.I3

Singleton {
    id: root

    property var mode: "default"
    Process {
        running: true
        command: ["swaymsg", "-t", "subscribe", "-m", '["mode"]']
        stdout: SplitParser {
            onRead: line => {
                try {
                    const event = JSON.parse(line);
                    mode = event.change;
                } catch (e) {
                    console.error("Failed to parse IPC event:", e);
                }
            }
        }
    }

    // { number: number, monitor: string, focused: bool, empty: bool }[]
    property var workspaces: {
        const workspaces = I3.workspaces.values.map(w => ({
                    number: w.number,
                    monitor: w.monitor.name,
                    focused: w.focused,
                    active: w.active,
                    empty: false
                }));
        const workspaceMaps = new Map(workspaces.map(w => [w.number, w]));
        const maxWorkspaceNumber = Math.max(0, ...workspaces.map(w => w.number));

        return Array(maxWorkspaceNumber).fill(0).map((_, i) => {
            const workspaceNumber = i + 1;
            return workspaceMaps.get(workspaceNumber) ?? {
                number: workspaceNumber,
                monitor: null,
                focused: false,
                active: false,
                empty: true
            };
        });
    }

    function activateWorkspace(number) {
        I3.dispatch(`workspace number ${number}`);
    }
}
