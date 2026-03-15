import QtQuick
import QtQuick.Layouts

import qs.components
import qs.components.musicPlayerControl
import qs.configs
import qs.states

Column {
    id: root

    required property var player

    spacing: Spacing.md

    RowLayout {
        width: parent.width

        TrackArtImage {}

        Padding {
            padding: Spacing.sm
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop

            Column {
                width: parent.width

                TextPadding {
                    width: parent.width
                    padding: 0

                    Typography {
                        text: root.player.trackTitle
                        fontSize: FontSize.md
                        elide: Text.ElideRight
                    }
                }

                TextPadding {
                    width: parent.width
                    padding: 0

                    Typography {
                        text: root.player.trackArtist
                        color: Color.foreground1
                        elide: Text.ElideRight
                    }
                }

                Padding {}

                TrackController {
                    width: parent.width
                    player: root.player
                }
            }
        }
    }

    SeekBar {
        width: parent.width
        player: root.player
    }
}
