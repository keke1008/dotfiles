import QtQuick
import Quickshell
import Quickshell.Io

import qs.states

import "modules/bar"
import "modules/drawer"
import "modules/transientOverlay"

ShellRoot {
    Variants {
        model: Quickshell.screens

        Scope {
            required property ShellScreen modelData

            Bar {
                screen: modelData
            }
        }
    }

    Drawer {}
    TransientOverlay {}

    IpcHandler {
        target: "app"

        function toggleFocusDrawer(): void {
            ApplicationState.toggleFocusDrawer();
        }
    }
}
