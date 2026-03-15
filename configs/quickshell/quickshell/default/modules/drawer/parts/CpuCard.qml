import QtQuick
import QtQuick.Layouts

import qs.components
import qs.configs
import qs.states

Card {
    id: root
    width: parent.width

    CpuStateTracker {
        id: cpuState
    }

    Column {
        width: parent.width
        spacing: Spacing.sm

        Item {
            width: parent.width
            height: childrenRect.height

            TextPadding {
                Typography {
                    text: "CPU"
                    fontSize: FontSize.md
                }
            }

            TextPadding {
                anchors.right: parent.right

                Typography {
                    text: Math.ceil(cpuState.usage * 100) + "%"
                }
            }
        }

        HorizontalDivider {}

        Padding {
            width: parent.width
            padding: Spacing.md

            Grid {
                id: grid

                readonly property real cellSize: 32
                readonly property real cellBorderWidth: 1
                readonly property real minSpacing: 6

                columns: {
                    const totalCellWidth = cellSize + cellBorderWidth * 2;
                    return Math.floor((parent.width + minSpacing) / (totalCellWidth + minSpacing));
                }
                rowSpacing: {
                    const totalCellWidth = cellSize + cellBorderWidth * 2;
                    return (parent.width - columns * totalCellWidth) / (columns - 1);
                }
                columnSpacing: rowSpacing

                Repeater {
                    model: cpuState.usages

                    Rectangle {
                        id: cell

                        required property var modelData

                        width: grid.cellSize + grid.cellBorderWidth * 2
                        height: grid.cellSize + grid.cellBorderWidth * 2

                        border.width: grid.cellBorderWidth
                        border.color: Color.border
                        radius: Radius.sm + grid.cellBorderWidth

                        color: Color.background1

                        Rectangle {
                            width: grid.cellSize
                            height: grid.cellSize * Math.min(modelData.usage, 1)
                            anchors {
                                bottom: parent.bottom
                                bottomMargin: grid.cellBorderWidth
                                horizontalCenter: parent.horizontalCenter
                            }
                            radius: Radius.sm

                            color: {
                                if (modelData.usage < 0.5) {
                                    return Color.info;
                                } else if (modelData.usage < 0.8) {
                                    return Color.warning;
                                } else {
                                    return Color.error;
                                }
                            }

                            Behavior on height {
                                NumberAnimation {
                                    duration: 100
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
