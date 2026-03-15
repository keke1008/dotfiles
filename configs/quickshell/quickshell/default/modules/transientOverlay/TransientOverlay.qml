import QtQuick
import QtQuick.Shapes
import Quickshell

import qs.configs
import qs.states

PanelWindow {
    id: root

    property real __padding: Spacing.md

    screen: ApplicationState.screen
    anchors {
        top: true
        bottom: true
        right: true
    }
    margins.right: ApplicationState.transientOverlayRightMargin
    implicitWidth: 400
    exclusionMode: ExclusionMode.Normal
    mask: Region {
        width: root.width
        height: root.height

        Region {
            item: transientContent
            intersection: Intersection.Intersect
        }
    }

    color: "transparent"

    Rectangle {
        id: transientContent
        width: root.implicitWidth
        height: transientNotifications.height === 0 ? 0 : transientNotifications.height + root.__padding * 2
        bottomLeftRadius: Radius.xl
        color: Color.background0

        TransientNotifications {
            id: transientNotifications
            width: parent.width - root.__padding * 2
            anchors.centerIn: parent
        }

        Behavior on implicitHeight {
            NumberAnimation {
                duration: AnimationDuration.fast
                easing.type: Easing.Linear
            }
        }
    }
}
