import QtQuick

import qs.components

Item {
    id: root

    visible: false

    required property RefCounter refCounter

    Component.onCompleted: {
        root.refCounter.incrementRefCount();
    }

    Component.onDestruction: {
        root.refCounter.decrementRefCount();
    }
}
