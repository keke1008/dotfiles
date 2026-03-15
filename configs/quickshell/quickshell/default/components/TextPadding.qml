import QtQuick

import qs.components
import qs.configs

Item {
    id: root

    default property alias data: content.data
    property bool square: false
    property color color

    property real __fontSize: content.children?.[0]?.font?.pixelSize ?? FontSize.md
    property real padding: root.__fontSize / 2
    property real horizontalPadding: root.padding
    property real verticalPadding: root.padding
    property real leftPadding: root.horizontalPadding
    property real rightPadding: root.horizontalPadding
    property real topPadding: root.verticalPadding
    property real bottomPadding: root.verticalPadding

    implicitWidth: content.implicitWidth + root.leftPadding + root.rightPadding
    implicitHeight: content.implicitHeight + root.topPadding + root.bottomPadding

    Item {
        id: wrapper

        width: root.width - root.leftPadding - root.rightPadding
        height: root.height - root.topPadding - root.bottomPadding
        anchors {
            left: root.left
            right: root.right
            top: root.top
            bottom: root.bottom

            leftMargin: root.leftPadding
            rightMargin: root.rightPadding
            topMargin: root.topPadding
            bottomMargin: root.bottomPadding
        }

        Item {
            id: content

            implicitWidth: (root.square ? root.__fontSize : content.children[0].width)
            implicitHeight: root.__fontSize

            width: wrapper.width
            height: wrapper.height

            Binding {
                target: content.children[0].anchors
                property: "centerIn"
                value: content
            }

            Binding {
                target: content.children[0]
                property: "width"
                value: wrapper.width
                when: !root.square
            }

            Binding {
                target: content.children[0]
                property: "color"
                value: root.color
                when: root.color.valid
            }
        }
    }
}
