import QtQuick
import QtQuick.Layouts

import qs.components
import qs.configs
import qs.states
import qs.modules.drawer.parts

Column {
    id: root
    spacing: Spacing.lg

    CpuCard {}
    MemoryCard {}
    BatteryCard {}
    IdleInhibitorCard {}
    SystemTrayCard {}
}
