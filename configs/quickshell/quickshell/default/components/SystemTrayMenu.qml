import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

import qs.components
import qs.components.systemTrayMenu
import qs.configs
import qs.states

Column {
    id: root

    required property SystemTrayItem menuItem

    property bool __opened: false

    ClickableArea {
        width: parent.width
        height: menuItemInfo.height
        radius: Radius.md
        onClicked: {
            root.__opened = !root.__opened;
        }

        Padding {
            id: menuItemInfo

            width: parent.width
            RowLayout {
                width: parent.width
                spacing: Spacing.md

                Fallback {
                    id: iconFallback

                    readonly property real __iconSize: 24

                    width: this.__iconSize
                    height: this.__iconSize

                    Image {
                        id: image
                        width: iconFallback.__iconSize
                        height: iconFallback.__iconSize
                        source: root.menuItem.icon
                        fillMode: Image.PreserveAspectCrop

                        Binding {
                            target: iconFallback
                            property: "isError"
                            value: root.menuItem.icon === "" || image.status === Image.Error
                        }
                    }
                }

                TextPadding {
                    Typography {
                        text: root.menuItem.id
                    }
                }

                Item {
                    Layout.fillWidth: true
                }
            }
        }

        ClickableArea {
            anchors.right: parent.right

            width: parent.height
            height: parent.height
            topRightRadius: Radius.md
            bottomRightRadius: Radius.md

            visible: !root.menuItem.onlyMenu
            onClicked: {
                root.menuItem.activate();
            }

            Typography {
                anchors.centerIn: parent
                fontSize: FontSize.md
                text: "󰏌"
            }
        }
    }

    Loader {
        active: root.menuItem.hasMenu && root.__opened
        height: this.item?.implicitHeight ?? 0

        sourceComponent: SystemTrayMenuEntryList {
            QsMenuOpener {
                id: menuEntries
                menu: root.menuItem.menu
            }

            width: parent.parent.width
            entries: menuEntries.children
        }
    }
}
