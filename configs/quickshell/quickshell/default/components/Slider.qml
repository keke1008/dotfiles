import QtQuick
import QtQuick.Controls

import qs.configs
import qs.components

Slider {
    id: slider

    height: slider.handleSize

    property bool disabled: false
    enabled: !slider.disabled

    readonly property real handleSize: 12
    readonly property real focusedHandleSize: 24

    background: Rectangle {
        x: slider.leftPadding + (slider.focusedHandleSize - slider.handleSize) / 2
        y: slider.topPadding + slider.availableHeight / 2 - height / 2
        width: parent.availableWidth - (slider.focusedHandleSize - slider.handleSize)
        height: Spacing.sm

        color: Color.border
    }

    handle: Rectangle {
        x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
        y: slider.topPadding + slider.availableHeight / 2 - height / 2
        width: slider.focusedHandleSize
        height: slider.focusedHandleSize
        radius: slider.focusedHandleSize / 2

        color: !slider.disabled && (slider.hovered || (slider.activeFocus && [Qt.TabFocusReason, Qt.BacktabFocusReason].includes(slider.focusReason))) ? Color.background2 : "transparent"

        Rectangle {
            width: slider.handleSize
            height: width
            anchors.centerIn: parent
            radius: 20
            color: slider.disabled ? Color.disabled : Color.primary
        }
    }
}
