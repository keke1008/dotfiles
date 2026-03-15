import Quickshell

import qs.components
import qs.configs

Typography {
    id: root

    property alias fontSize: root.fontSize
    property alias color: root.color

    required property list<string> icons
    required property real value
    property real min: 0
    property real max: 1

    text: {
        if (icons.length === 0) {
            throw new Error("icons is empty array");
        }
        if (icons.length === 1) {
            return icons[0];
        }
        if (value <= min) {
            return icons[0];
        } else if (value >= max || icons.length === 2) {
            return icons[icons.length - 1];
        }

        const middleIcons = icons.slice(1, -1);
        const normalizedValue = (value - min) / (max - min);
        const middleIconIndex = Math.round(normalizedValue * (middleIcons.length - 1));
        const middleIcon = middleIcons[middleIconIndex];
        if (middleIcon === undefined) {
            throw new Error(`middleIcon is undefined. value: ${value}, min: ${min}, max: ${max}, normalizedValue: ${normalizedValue}, middleIconIndex: ${middleIconIndex}, middleIcons.length: ${middleIcons.length}`);
        }

        return middleIcon;
    }
}
