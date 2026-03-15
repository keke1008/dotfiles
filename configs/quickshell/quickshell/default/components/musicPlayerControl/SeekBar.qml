import QtQuick
import QtQuick.Layouts

import qs.components
import qs.components.musicPlayerControl
import qs.configs

RowLayout {
    id: root
    required property var player

    Slider {
        Layout.fillWidth: true
        disabled: true

        from: 0
        to: root.player.length
        value: root.player.position
    }

    TextPadding {
        Typography {
            text: {
                const hour = Math.floor(root.player.position / 3600);
                const minute = Math.floor(root.player.position / 60);
                const second = Math.round(root.player.position % 60);
                const fmt = val => val.toString().padStart(2, '0');
                return `${fmt(hour)}:${fmt(minute)}:${fmt(second)}`;
            }
        }
    }
}
