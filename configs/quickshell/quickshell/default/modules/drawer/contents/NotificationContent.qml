import QtQuick
import QtQuick.Layouts

import qs.components
import qs.configs
import qs.states

Column {
    spacing: Spacing.lg
    width: parent.width

    Button {
        width: parent.width
        role: "secondary"
        onClicked: {
            NotificationState.clearAllNotifications();
        }

        TextPadding {
            Typography {
                text: "Clear"
            }
        }
    }

    Column {
        spacing: Spacing.md
        width: parent.width

        add: Transition {
            NumberAnimation {
                properties: "x"
                from: parent.width
                duration: AnimationDuration.slow
                easing.type: Easing.InOutQuad
            }
        }

        move: Transition {
            NumberAnimation {
                property: "y"
                duration: AnimationDuration.fast
                easing.type: Easing.Linear
            }
        }

        Repeater {
            model: NotificationState.persistentNotifications

            NotificationToast {
                required property var modelData

                notification: modelData
                onDismiss: {
                    NotificationState.dismissNotification(modelData.id);
                }
            }
        }
    }
}
