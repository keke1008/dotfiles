import QtQuick
import QtQuick.Effects

import qs.components
import qs.configs

RoundedEffect {
    id: root

    required property var notification

    property int __iconSize: 32

    width: root.__iconSize
    height: root.__iconSize

    Fallback {
        id: fallback
        width: root.__iconSize
        height: root.__iconSize

        fallback: MaterialSymbolsIcon {
            fontSize: root.__iconSize
            name: "info"
        }

        Image {
            id: image

            width: root.__iconSize
            height: root.__iconSize
            source: root.notification.appIcon
            fillMode: Image.PreserveAspectCrop

            Binding {
                target: fallback
                property: "isError"
                value: root.notification.appIcon === "" || image.status === Image.Error
            }
        }
    }
}
