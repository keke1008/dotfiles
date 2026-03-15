import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.components
import qs.configs
import qs.states

Card {
    width: parent.width

    Column {
        width: parent.width
        spacing: Spacing.md

        Item {
            width: parent.width
            height: childrenRect.height

            TextPadding {
                Typography {
                    text: "Bluetooth"
                    color: Color.foreground0
                    fontSize: FontSize.md
                }
            }

            IconButton {
                anchors.right: parent.right
                disabled: !BluetoothState.enabled
                onClicked: {
                    BluetoothState.toggleEnabled();
                }

                TextPadding {
                    square: true
                    Typography {
                        fontSize: FontSize.md
                        text: BluetoothState.enabled ? "󰂯" : "󰂲"
                    }
                }
            }
        }

        HorizontalDivider {}

        Repeater {
            id: repeater
            model: BluetoothState.devices

            ClickableArea {
                id: device
                required property var modelData

                width: parent.parent.width
                height: childrenRect.height
                radius: Radius.md

                onClicked: {
                    BluetoothState.toggleConnection(modelData.address);
                }

                RowLayout {
                    width: parent.width
                    spacing: Spacing.sm

                    Component {
                        id: connectedIndicator
                        TextPadding {
                            square: true
                            Typography {
                                text: ""
                                color: Color.primary
                            }
                        }
                    }

                    Component {
                        id: stateUpdateingIndicator
                        TextPadding {
                            square: true
                            ProgressIcon {}
                        }
                    }

                    Component {
                        id: disconnectedIndicator
                        TextPadding {
                            square: true
                            Typography {
                                text: ""
                            }
                        }
                    }

                    Loader {
                        sourceComponent: {
                            if (modelData.connected) {
                                return connectedIndicator;
                            } else if (modelData.stateUpdating) {
                                return stateUpdateingIndicator;
                            } else {
                                return disconnectedIndicator;
                            }
                        }
                    }

                    TextPadding {
                        Typography {
                            text: modelData.name
                        }
                    }

                    TextPadding {
                        Layout.fillWidth: true
                        Typography {}
                    }

                    Loader {
                        active: modelData.battery !== undefined
                        sourceComponent: RowLayout {
                            TextPadding {
                                horizontalPadding: 0
                                Typography {
                                    text: `${modelData.battery * 100}%`
                                }
                            }

                            TextPadding {
                                BatteryIcon {
                                    value: modelData.battery
                                    fontSize: FontSize.md
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
