import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.components
import qs.configs
import qs.states

Card {
    width: parent.width

    ColumnLayout {
        implicitWidth: parent.width

        RowLayout {
            Layout.fillWidth: true

            TextPadding {
                Typography {
                    text: "Wi-Fi"
                    fontSize: FontSize.md
                }
            }

            Item {
                Layout.fillWidth: true
            }

            IconButton {
                disabled: !WifiState.enabled
                onClicked: {
                    WifiState.toggleEnabled();
                }

                TextPadding {
                    square: true
                    Typography {
                        fontSize: FontSize.md
                        text: WifiState.enabled ? "󰤥" : "󰤯"
                    }
                }
            }
        }

        HorizontalDivider {}

        Repeater {
            implicitWidth: parent.width
            model: WifiState.networks

            RowLayout {
                Layout.fillWidth: true
                spacing: Spacing.sm

                TextPadding {
                    square: true
                    Typography {
                        text: modelData.state === "Connected" ? "" : ""
                        color: Color.primary
                    }
                }

                TextPadding {
                    Typography {
                        text: modelData.name
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                TextPadding {
                    Typography {
                        text: Math.ceil(modelData.strength * 100) + "%"
                    }
                }
            }
        }
    }
}
