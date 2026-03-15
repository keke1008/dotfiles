import qs.states

Tracker {
    refCounter: MemoryState.refCounter

    readonly property real usage: MemoryState.usage
    readonly property real totalGiB: MemoryState.totalGiB
    readonly property real usedGiB: MemoryState.usedGiB
}
