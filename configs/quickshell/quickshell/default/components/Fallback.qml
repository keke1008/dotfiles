import QtQuick

import qs.configs

Item {
    id: root

    default required property Component content
    property bool isError: false

    property Component fallback: MaterialSymbolsIcon {
        name: "broken_image"
        fontSize: FontSize.lg
    }

    Loader {
        anchors.centerIn: root

        sourceComponent: {
            return root.isError ? fallback : root.content;
        }
    }
}
