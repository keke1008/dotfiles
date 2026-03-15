import QtQuick
import QtQuick.Layouts

import qs.components
import qs.configs
import qs.states

Card {
    width: parent.parent.width
    visible: MusicPlayerState.players.values.length >= 1

    Column {
        width: parent.width
        spacing: Spacing.md

        TextPadding {
            Typography {
                text: "Player"
                fontSize: FontSize.md
            }
        }

        HorizontalDivider {}

        Padding {
            width: parent.width
            verticalPadding: 0

            Column {
                width: parent.width
                spacing: Spacing.md

                Repeater {
                    model: MusicPlayerState.players

                    Padding {
                        width: parent.width
                        required property var modelData
                        required property int index

                        MusicPlayerControl {
                            width: parent.width
                            player: modelData
                        }
                    }
                }
            }
        }
    }
}
