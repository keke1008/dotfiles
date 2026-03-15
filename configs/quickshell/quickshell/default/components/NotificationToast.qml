import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

import qs.components
import qs.components.notificationToast
import qs.configs
import qs.states

ClickableArea {
    id: root

    required property var notification
    property bool expanded: false
    property real padding: Spacing.lg

    implicitWidth: parent.width
    implicitHeight: content.height
    clip: true

    signal dismiss(var notificationId)

    radius: 10
    colors: ({
            normal: Color.background1
        })
    onClicked: {
        if (root.notification.defaultAction === undefined) {
            root.dismiss(notification.id);
        } else {
            NotificationState.invokeAction(notification.id, notification.defaultAction.identifier);
        }
    }

    Item {
        id: content
        width: parent.width
        height: bodyRow.height + root.padding * 2

        RowLayout {
            id: bodyRow
            width: parent.width
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: root.padding
            anchors.rightMargin: root.padding
            anchors.topMargin: root.padding
            spacing: Spacing.md

            NotificationToastIcon {
                id: iconRoot
                notification: root.notification
                Layout.alignment: Qt.AlignTop
            }

            Loader {
                Layout.fillWidth: true
                sourceComponent: root.expanded ? bodyExpanded : bodyCollapsed
            }

            Component {
                id: bodyCollapsed
                NotificationToastBodyCollapsed {
                    width: parent.width
                    notification: root.notification
                }
            }

            Component {
                id: bodyExpanded
                NotificationToastBodyExpanded {
                    notification: root.notification
                }
            }
        }

        ClickableArea {
            width: 50
            height: parent.height
            anchors.right: parent.right
            topRightRadius: root.radius
            bottomRightRadius: root.radius

            onClicked: root.expanded = !root.expanded

            MaterialSymbolsIcon {
                anchors.centerIn: parent
                visible: parent.state !== "normal"

                name: root.expanded ? "collapse_all" : "expand_all"
                fontSize: FontSize.md
            }
        }
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: AnimationDuration.fast
            easing.type: Easing.Linear
        }
    }
}
