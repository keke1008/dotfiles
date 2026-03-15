import QtQuick
import QtQuick.Layouts

import qs.components
import qs.configs
import qs.states

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
        id: content
        model: NotificationState.transientNotifications

        NotificationToast {
            required property var modelData

            notification: modelData
            onDismiss: {
                NotificationState.hideNotification(modelData.id);
            }
        }
    }
}
