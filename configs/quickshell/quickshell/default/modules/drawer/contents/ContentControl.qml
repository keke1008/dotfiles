import QtQuick
import QtQuick.Layouts

import qs.configs
import qs.components
import qs.states

Item {
    id: root

    width: parent.width
    height: childrenRect.height

    Row {
        spacing: Spacing.sm

        IconButton {
            onClicked: {
                ApplicationState.toggleShowDrawer();
            }

            TextPadding {
                square: true
                Typography {
                    fontSize: FontSize.md
                    text: ""
                }
            }
        }

        IconButton {
            active: ApplicationState.pinDrawer
            onClicked: {
                ApplicationState.pinDrawer = !ApplicationState.pinDrawer;
            }

            TextPadding {
                square: true
                Typography {
                    fontSize: FontSize.md
                    text: "󰡎"
                }
            }
        }
    }

    Row {
        anchors.right: root.right
        spacing: Spacing.sm

        Repeater {
            model: [
                {
                    content: "notification",
                    icon: NotificationState.persistentNotifications.count >= 1 ? "󱥁" : "󰍥"
                },
                {
                    content: "system",
                    icon: ""
                },
                {
                    content: "connection",
                    icon: "󱘖"
                },
                {
                    content: "audio",
                    icon: "󰝚"
                }
            ]

            IconButton {
                required property var modelData

                active: modelData.content === ApplicationState.drawerContent
                onClicked: {
                    ApplicationState.drawerContent = modelData.content;
                }

                TextPadding {
                    square: true
                    Typography {
                        fontSize: FontSize.md
                        text: modelData.icon
                    }
                }
            }
        }
    }
}
