import QtQuick

import qs.components
import qs.configs

Item {
    id: root
    width: 100
    height: this.width

    RoundedEffect {
        Fallback {
            id: fallback
            width: root.width
            height: root.height
            Image {
                id: image

                width: root.width
                height: root.height
                source: player.trackArtUrl
                fillMode: Image.PreserveAspectCrop

                Binding {
                    target: fallback
                    property: "isError"
                    value: player.trackArtUrl === "" || image.status === Image.Error
                }
            }
        }
    }
}
