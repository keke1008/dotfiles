import QtQuick

QtObject {
    id: root

    property int __refCount: 0
    readonly property bool active: root.__refCount >= 1

    function incrementRefCount() {
        root.__refCount++;
    }

    function decrementRefCount() {
        root.__refCount--;
    }
}
