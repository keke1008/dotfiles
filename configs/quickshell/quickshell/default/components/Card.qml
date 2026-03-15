import QtQuick
import QtQuick.Controls
import qs.configs

Rectangle {
    id: root

    default property alias content: container.data
    property int padding: Spacing.md

    implicitWidth: container.implicitWidth + padding * 2
    implicitHeight: container.implicitHeight + padding * 2

    color: Color.background1
    radius: Radius.md

    Item {
        id: container
        anchors {
            fill: parent
            margins: root.padding
        }

        implicitWidth: childrenRect.width
        implicitHeight: childrenRect.height
    }
}
