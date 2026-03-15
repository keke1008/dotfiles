import QtQuick
import QtQuick.Layouts

import qs.components
import qs.configs
import qs.states

Row {
    required property var player

    IconButton {
        onClicked: {
            MusicPlayerState.skipPrevious(player.id);
        }
        TextPadding {
            square: true
            padding: Spacing.sm
            Typography {
                fontSize: FontSize.lg
                text: "󰒮"
            }
        }
    }

    IconButton {
        onClicked: {
            MusicPlayerState.togglePlaying(player.id);
        }
        TextPadding {
            square: true
            padding: Spacing.sm
            Typography {
                fontSize: FontSize.lg
                text: player.isPlaying ? "󰏤" : "󰐊"
            }
        }
    }

    IconButton {
        onClicked: {
            MusicPlayerState.skipNext(player.id);
        }
        TextPadding {
            square: true
            padding: Spacing.sm
            Typography {
                fontSize: FontSize.lg
                text: "󰒭"
            }
        }
    }
}
