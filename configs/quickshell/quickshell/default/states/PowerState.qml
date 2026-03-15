pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    readonly property var __battery: UPower.devices.values.find(dev => dev.isLaptopBattery)

    readonly property var battery: __battery && {
        energyCapacityWh: __battery.energyCapacity,
        energyWh: __battery.energy,
        energyRatio: __battery.percentage,
        energyPercentage: __battery.percentage * 100,
        state: UPowerDeviceState.toString(__battery.state),
        charging: [UPowerDeviceState.Charging, UPowerDeviceState.PendingCharge].includes(__battery.state)
    }

    readonly property string powerProfile: PowerProfile.toString(PowerProfiles.profile)
    readonly property bool enablePowerProfile: PowerProfiles.hasPerformanceProfile

    function setPowerProfile(profile) {
        const map = {
            "Performance": PowerProfiles.Performance,
            "Balanced": PowerProfiles.Balanced,
            "PowerSaver": PowerProfiles.PowerSaver
        };

        if (profile in map) {
            PowerProfiles.profile = map[profile];
        } else {
            console.warn(`Unknown power profile: ${profile}`);
        }
    }
}
