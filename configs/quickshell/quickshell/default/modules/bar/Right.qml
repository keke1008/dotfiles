import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.components
import qs.configs
import qs.states

Item {
    id: root
    width: layout.implicitWidth
    height: layout.implicitHeight

    property bool showPopup: false

    MouseArea {
        anchors.fill: parent
        onClicked: {
            showPopup = !showPopup;
        }
    }

    Row {
        id: layout

        IconButton {
            disabled: !WifiState.enabled
            onClicked: WifiState.toggleEnabled()

            TextPadding {
                verticalPadding: 0
                PhasedIcon {
                    icons: WifiState.enabled ? ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"] : ["󰤮"]
                    value: WifiState.connectedNetwork?.strength ?? 0
                    fontSize: FontSize.md
                }
            }
        }

        TextPadding {
            verticalPadding: 0
            PhasedIcon {
                icons: ["󰲜", "󰛳"]
                value: WiredNetworkState.connectedNetwork !== undefined
                color: WiredNetworkState.connectedNetwork ? Color.foreground0 : Color.disabled
                fontSize: FontSize.md
            }
        }

        IconButton {
            disabled: !BluetoothState.enabled
            onClicked: BluetoothState.toggleEnabled()

            TextPadding {
                verticalPadding: 0
                PhasedIcon {
                    icons: ["󰂲", "󰂯"]
                    value: BluetoothState.enabled + 0
                    fontSize: FontSize.md
                }
            }
        }

        IconButton {
            disabled: AudioState.defaultSink === undefined || AudioState.defaultSink.muted
            onClicked: AudioState.setMute(AudioState.defaultSink.id, !AudioState.defaultSink.muted)

            TextPadding {
                verticalPadding: 0
                PhasedIcon {
                    icons: ["󰖁", "󰕾"]
                    value: AudioState.defaultSink?.muted ? 0 : AudioState.defaultSink?.volume ?? 0
                    fontSize: FontSize.md
                }
            }
        }

        IconButton {
            disabled: AudioState.defaultSource === undefined || AudioState.defaultSource.muted
            onClicked: AudioState.setMute(AudioState.defaultSource.id, !AudioState.defaultSource.muted)

            TextPadding {
                verticalPadding: 0
                PhasedIcon {
                    icons: ["󰍭", "󰍬"]
                    value: AudioState.defaultSource?.muted ? 0 : AudioState.defaultSource?.volume ?? 0
                    fontSize: FontSize.md
                }
            }
        }

        Loader {
            active: PowerState.battery !== undefined
            sourceComponent: TextPadding {
                verticalPadding: 0
                BatteryIcon {
                    value: (PowerState.battery.energyRatio)
                    charging: PowerState.battery.charging
                    fontSize: FontSize.md
                }
            }
        }

        TextPadding {
            verticalPadding: 0
            Typography {
                text: Qt.formatDateTime(TimeState.time, "hh:mm")
                fontSize: FontSize.md
            }
        }
    }
}
