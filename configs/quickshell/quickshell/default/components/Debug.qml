import QtQuick
import QtQuick.Controls

Item {
    id: root
    required property var value

    width: 0
    height: 0

    Component.onCompleted: {
        console.debug(debugText.text);
    }

    Rectangle {

        width: debugText.implicitWidth + 16
        height: debugText.implicitHeight + 16

        color: "#11111111"
        border.color: "#99990000"
        z: 9999

        Text {
            id: debugText

            anchors.centerIn: parent
            color: "#DDDDDD"
            font.pixelSize: 16
            font.bold: true

            text: {
                const result = JSON.stringify(root.value, null, 2);
                return result === undefined ? "undefined" : result;
            }
        }
    }
}
