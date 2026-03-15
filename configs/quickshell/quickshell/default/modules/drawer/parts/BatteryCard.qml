import QtQuick
import QtQuick.Layouts

import qs.components
import qs.configs
import qs.states

Loader {
    id: root
    active: PowerState.battery !== undefined

    sourceComponent: Card {
        implicitWidth: root.parent.width

        Column {
            width: parent.width
            spacing: Spacing.md

            Item {
                width: parent.width
                height: childrenRect.height

                TextPadding {
                    Typography {
                        text: "Battery"
                        fontSize: FontSize.md
                    }
                }

                Row {
                    anchors.right: parent.right

                    TextPadding {
                        visible: PowerState.battery.charging
                        square: true
                        Typography {
                            text: "󱐋"
                            fontSize: FontSize.md
                            color: Color.primary
                        }
                    }

                    Padding {
                        visible: PowerState.battery.charging && PowerState.enablePowerProfile

                        height: parent.height
                        verticalPadding: 0
                        Rectangle {
                            height: parent.height
                            width: 1
                            color: Color.border
                        }
                    }

                    Loader {
                        active: PowerState.enablePowerProfile
                        sourceComponent: Row {
                            spacing: 0
                            Repeater {
                                id: profileRepeater
                                property var profileIcons: {
                                    "PowerSaver": "󰋑",
                                    "Balanced": "󰁹",
                                    "Performance": "󰈸"
                                }
                                property list<string> profileOptions: Object.keys(profileIcons)
                                model: profileOptions

                                IconButton {
                                    required property var modelData
                                    active: modelData === PowerState.powerProfile
                                    onClicked: PowerState.setPowerProfile(modelData)

                                    TextPadding {
                                        square: true
                                        Typography {
                                            fontSize: FontSize.md
                                            text: profileRepeater.profileIcons[modelData]
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            HorizontalDivider {}

            Padding {
                width: parent.width

                RowLayout {
                    width: parent.width
                    spacing: Spacing.lg

                    Typography {
                        text: `${PowerState.battery.energyPercentage.toFixed(1)}%`
                    }

                    Meter {
                        height: 24
                        value: PowerState.battery.energyRatio
                        color: Color.background1
                        fillColor: {
                            if (PowerState.battery.energyRatio < 0.1) {
                                return Color.error;
                            } else if (PowerState.battery.energyRatio < 0.2) {
                                return Color.warning;
                            } else {
                                return Color.info;
                            }
                        }
                    }
                }
            }
        }
    }
}
