import QtQuick
import QtQuick.Layouts

import qs.components
import qs.configs
import qs.states

Card {
    id: root
    implicitWidth: parent.width

    Item {
        width: parent.width
        height: childrenRect.height

        TextPadding {
            Typography {
                text: "Idle Inhibitor"
                fontSize: FontSize.md
            }
        }

        IconButton {
            anchors.right: parent.right

            disabled: !IdleInhibitorState.enabled
            onClicked: IdleInhibitorState.toggleEnabled()

            TextPadding {
                Typography {
                    text: IdleInhibitorState.enabled ? "󰈈" : "󰒲"
                    fontSize: FontSize.md
                }
            }
        }
    }
}
