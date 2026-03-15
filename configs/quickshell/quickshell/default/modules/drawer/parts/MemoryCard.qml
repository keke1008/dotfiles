import QtQuick
import QtQuick.Layouts

import qs.components
import qs.configs
import qs.states

Card {
    id: root
    width: parent.width

    MemoryStateTracker {
        id: memoryState
    }

    Column {
        width: parent.width
        spacing: Spacing.sm

        Item {
            width: parent.width
            height: childrenRect.height

            TextPadding {
                Typography {
                    text: "Memory"
                    fontSize: FontSize.md
                }
            }

            TextPadding {
                anchors.right: parent.right

                Typography {
                    text: `${memoryState.usedGiB.toFixed(2)} / ${memoryState.totalGiB.toFixed(2)} GiB`
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
                    text: `${(memoryState.usage * 100).toFixed(1)}%`
                }

                Meter {
                    height: 24
                    value: memoryState.usage
                    color: Color.background1
                    fillColor: {
                        if (memoryState.usage < 0.5) {
                            return Color.info;
                        } else if (memoryState.usage < 0.8) {
                            return Color.warning;
                        } else {
                            return Color.error;
                        }
                    }
                }
            }
        }
    }
}
