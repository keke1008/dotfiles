import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.components.systemTrayMenu
import qs.components
import qs.configs

Column {
    id: root

    required property QsMenuEntry entry
    property bool __opened: false

    width: parent.width

    Loader {
        sourceComponent: root.entry.isSeparator ? separator : itemEntry
    }

    Component {
        id: separator

        HorizontalDivider {
            width: root.width
        }
    }

    Component {
        id: itemEntry
        ClickableArea {
            width: root.width

            radius: Radius.md
            onClicked: {
                root.entry.triggered();
                root.__opened = !root.__opened;
            }

            Padding {
                width: parent.width
                padding: Spacing.sm

                RowLayout {
                    width: parent.width
                    spacing: Spacing.md

                    Fallback {
                        id: iconFallback

                        readonly property real __iconSize: FontSize.sm

                        width: this.__iconSize
                        height: this.__iconSize

                        Image {
                            id: image
                            width: iconFallback.__iconSize
                            height: iconFallback.__iconSize
                            source: root.entry.icon
                            fillMode: Image.PreserveAspectCrop
                        }
                    }

                    Typography {
                        text: root.entry.text
                        color: root.entry.enabled ? Color.foreground0 : Color.disabled
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    TextPadding {
                        visible: root.entry.hasChildren
                        square: true
                        padding: 0
                        Typography {
                            text: "󰅀"
                        }
                    }
                }
            }
        }
    }

    Loader {
        active: root.__opened && root.entry.hasChildren
        height: this.item?.implicitHeight ?? 0

        sourceComponent: Padding {
            width: root.width
            padding: 0
            leftPadding: Spacing.xl

            SystemTrayMenuEntryList {
                QsMenuOpener {
                    id: childrenEntries
                    menu: root.entry
                }

                width: parent.width
                entries: childrenEntries.children
            }
        }
    }
}
