import QtQuick

import qs.configs

Text {
    id: root

    property alias text: root.text
    property alias color: root.color
    property alias textFormat: root.textFormat

    color: Color.foreground0
    font.family: "monospace"
    textFormat: Text.PlainText

    property int fontSize: FontSize.sm
    property bool bold: false

    font.pixelSize: root.fontSize
    font.bold: root.bold
}
