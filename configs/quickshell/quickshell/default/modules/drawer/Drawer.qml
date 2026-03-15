import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import qs.configs
import qs.components
import qs.states
import qs.modules.drawer.contents

Loader {
    active: ApplicationState.showDrawer
    sourceComponent: PanelWindow {
        id: root

        anchors {
            top: true
            bottom: true
            right: true
        }
        screen: ApplicationState.screen
        exclusionMode: ApplicationState.pinDrawer ? ExclusionMode.Auto : ExclusionMode.Normal
        implicitWidth: ApplicationState.drawerWidth

        WlrLayershell.keyboardFocus: ApplicationState.focusDrawer ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.OnDemand
        Shortcut {
            sequence: "Escape"
            onActivated: {
                ApplicationState.focusDrawer = false;
            }
        }

        color: Color.background0

        Padding {
            width: parent.width
            height: parent.height

            Column {
                width: parent.width
                height: parent.height
                spacing: Spacing.lg

                ContentControl {}

                Loader {
                    width: parent.width
                    height: parent.height

                    sourceComponent: {
                        const contents = {
                            connection: connectionContent,
                            notification: notificationContent,
                            system: systemContent,
                            audio: audioContent
                        };
                        return contents[ApplicationState.drawerContent];
                    }
                }

                Component {
                    id: connectionContent
                    ConnectionContent {}
                }

                Component {
                    id: notificationContent
                    NotificationContent {}
                }

                Component {
                    id: systemContent
                    SystemContent {}
                }

                Component {
                    id: audioContent

                    AudioContent {}
                }
            }
        }
    }
}
