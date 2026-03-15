import QtQuick

import qs.configs

Item {
    id: root

    default property alias data: content.data

    property real padding: Spacing.md
    property real horizontalPadding: root.padding
    property real verticalPadding: root.padding
    property real leftPadding: root.horizontalPadding
    property real rightPadding: root.horizontalPadding
    property real topPadding: root.verticalPadding
    property real bottomPadding: root.verticalPadding

    implicitWidth: content.implicitWidth + root.leftPadding + root.rightPadding
    implicitHeight: content.implicitHeight + root.topPadding + root.bottomPadding

    Item {
        width: root.width - root.leftPadding - root.rightPadding
        height: root.height - root.topPadding - root.bottomPadding
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom

            leftMargin: root.leftPadding
            rightMargin: root.rightPadding
            topMargin: root.topPadding
            bottomMargin: root.bottomPadding
        }

        Item {
            id: content

            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height

            width: parent.width
            height: parent.height
        }
    }
}
