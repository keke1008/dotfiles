import QtQuick
import QtQuick.Layouts

import qs.components
import qs.configs
import qs.states

Card {
    id: root

    width: parent.width

    readonly property int __volume: Math.round(AudioState.defaultSink.volume * 100)

    Column {
        width: parent.width
        spacing: Spacing.sm

        RowLayout {
            width: parent.width
            spacing: Spacing.sm

            TextPadding {
                Typography {
                    text: "Sink"
                    fontSize: FontSize.md
                }
            }

            IconButton {
                disabled: AudioState.defaultSink.muted
                onClicked: {
                    AudioState.setMute(AudioState.defaultSink.id, !AudioState.defaultSink.muted);
                }

                TextPadding {
                    square: true
                    Typography {
                        fontSize: FontSize.md
                        text: AudioState.defaultSink.muted ? "󰖁" : "󰕾"
                    }
                }
            }

            Slider {
                id: volumeSlider
                Layout.fillWidth: true

                from: 0
                to: 40
                stepSize: 1
                snapMode: Slider.SnapAlways
                value: root.__volume
                disabled: AudioState.defaultSink.muted

                onMoved: {
                    AudioState.setVolume(AudioState.defaultSink.id, volumeSlider.value / 100);
                }
            }

            TextPadding {
                Typography {
                    text: `${`${root.__volume}`.padStart(2, ' ')}%`
                }
            }
        }

        HorizontalDivider {}

        Repeater {
            width: parent.width
            model: AudioState.sinks

            ClickableArea {
                required property var modelData

                width: parent.width
                height: childrenRect.height
                radius: Radius.md
                onClicked: {
                    AudioState.setDefaultSink(modelData.id);
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
