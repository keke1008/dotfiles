import qs.states

Tracker {
    refCounter: CpuState.refCounter

    property real usage: CpuState.cpuUsage
    property var usages: CpuState.cpuUsages
}
