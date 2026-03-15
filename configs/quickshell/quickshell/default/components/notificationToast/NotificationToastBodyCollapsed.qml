import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

import qs.components
import qs.configs

Column {
    id: root

    required property var notification

    spacing: Spacing.sm

    Typography {
        width: root.width

        text: root.notification.summary
        fontSize: FontSize.md
        bold: true
        elide: Text.ElideRight
    }

    Typography {
        width: root.width

        text: root.notification.body
        fontSize: FontSize.sm
        textFormat: Text.StyledText
        elide: Text.ElideRight
    }
}
