import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.I3

import qs.components
import qs.configs
import qs.states

Row {
    id: root

    required property string monitorName

    spacing: Spacing.sm

    Repeater {
        model: I3State.workspaces

        IconButton {
            required property var modelData
            required property int index

            onClicked: I3State.activateWorkspace(modelData.number)

            disabled: modelData.empty
            active: modelData.monitor === root.monitorName && modelData.active

            TextPadding {
                square: true
                verticalPadding: 0
                horizontalPadding: Spacing.sm
                rightPadding: (index + 1) % 5 === 0 ? Spacing.md : 0

                Typography {
                    text: modelData.monitor === root.monitorName && modelData.active ? '' : ''
                    fontSize: FontSize.md
                }
            }
        }
    }

    TextPadding {
        square: true
        verticalPadding: 0
        Typography {
            text: {
                const map = {
                    default: "",
                    RESIZE: "󰩨"
                };
                return map[I3State.mode] ?? I3State.mode;
            }
            color: Color.primary
            fontSize: FontSize.md
        }
    }
}
