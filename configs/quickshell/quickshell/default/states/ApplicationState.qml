pragma Singleton

import QtQuick
import Quickshell
import Quickshell.I3

Singleton {
    id: root

    readonly property string screenName: props.screenName
    readonly property bool showDrawer: props.showDrawer
    property alias pinDrawer: props.pinDrawer
    property alias focusDrawer: props.focusDrawer
    property alias drawerContent: props.drawerContent

    readonly property real drawerWidth: 400
    readonly property real transientOverlayRightMargin: (props.showDrawer && !props.pinDrawer) ? root.drawerWidth : 0

    PersistentProperties {
        id: props
        reloadableId: "applicationState"

        property string screenName: Quickshell.screens[0].name
        property bool showDrawer: false
        property bool pinDrawer: false
        property bool focusDrawer: false
        property string drawerContent: "notification"
    }

    readonly property ShellScreen screen: {
        return [...Quickshell.screens.values()].find(s => s.name == props.screenName);
    }

    function __showDrawer(screen: string) {
        props.screenName = screen;
        props.focusDrawer = true;
        props.showDrawer = true;
    }

    function __hideDrawer() {
        props.focusDrawer = false;
        props.showDrawer = false;
    }

    function toggleShowDrawer() {
        if (props.showDrawer) {
            root.__hideDrawer();
        } else {
            root.__showDrawer();
        }
    }

    function toggleFocusDrawer() {
        const focusedMonitorName = I3.focusedMonitor.name;

        if (!props.showDrawer) {
            props.pinDrawer = false;
            root.__showDrawer(focusedMonitorName);
            return;
        }

        if (props.focusDrawer) {
            root.__hideDrawer();
        } else {
            root.__showDrawer(focusedMonitorName);
        }
    }
}
