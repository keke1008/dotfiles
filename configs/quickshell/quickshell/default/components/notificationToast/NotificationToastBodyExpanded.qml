import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

import qs.components
import qs.states
import qs.configs

Column {
    required property var notification

    spacing: Spacing.sm

    Typography {
        width: parent.parent.width

        text: root.notification.appName || "unknown app"
        elide: Text.ElideRight
    }

    Typography {
        width: parent.width

        text: root.notification.summary
        fontSize: FontSize.md
        bold: true
        wrapMode: Text.Wrap
    }

    Typography {
        width: parent.width

        text: root.notification.body
        fontSize: FontSize.sm
        textFormat: Text.StyledText
        wrapMode: Text.Wrap
    }

    Row {
        spacing: Spacing.md
        width: parent.parent.width

        Repeater {
            model: root.notification.actions

            Button {
                required property var modelData

                role: "secondary"
                onClicked: {
                    NotificationState.invokeAction(modelData.notificationId, modelData.identifier);
                }

                TextPadding {
                    Typography {
                        text: modelData.text
                    }
                }
            }
        }
    }
}
