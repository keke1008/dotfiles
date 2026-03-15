import QtQuick
import QtQuick.Layouts

import qs.components
import qs.configs
import qs.states

Card {
    id: root

    width: parent.width

    readonly property int __volume: Math.round(AudioState.defaultSource.volume * 100)

    Column {
        width: parent.width
        spacing: Spacing.sm

        RowLayout {
            width: parent.width
            spacing: Spacing.sm

            TextPadding {
                Typography {
                    text: "Source"
                    fontSize: FontSize.md
                }
            }

            IconButton {
                Layout.alignment: Qt.AlignVCenter
                disabled: AudioState.defaultSource.muted
                onClicked: {
                    AudioState.setMute(AudioState.defaultSource.id, !AudioState.defaultSource.muted);
                }

                TextPadding {
                    square: true
                    Typography {
                        fontSize: FontSize.md
                        text: AudioState.defaultSource.muted ? "󰍭" : "󰍬"
                    }
                }
            }

            Slider {
                id: volumeSlider
                Layout.fillWidth: true

                from: 0
                to: 100
                stepSize: 1
                snapMode: Slider.SnapAlways
                value: root.__volume
                disabled: AudioState.defaultSource.muted

                onMoved: {
                    AudioState.setVolume(AudioState.defaultSource.id, volumeSlider.value / 100);
                }
            }

            TextPadding {
                Typography {
                    text: `${`${root.__volume}`.padStart(3, ' ')}%`
                }
            }
        }

        HorizontalDivider {}

        Repeater {
            width: parent.width
            model: AudioState.sources

            ClickableArea {
                required property var modelData

                width: parent.width
                height: childrenRect.height
                radius: Radius.md
                onClicked: {
                    AudioState.setDefaultSource(modelData.id);
                }

                Row {
                    width: parent.width
                    height: childrenRect.height
                    spacing: Spacing.sm

                    TextPadding {
                        square: true
                        Typography {
                            text: modelData.default ? "" : ""
                            color: Color.primary
                        }
                    }

                    TextPadding {
                        Typography {
                            text: modelData.name
                        }
                    }
                }
            }
        }
    }
}
