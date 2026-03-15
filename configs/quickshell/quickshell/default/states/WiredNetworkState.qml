pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Networking

Singleton {
    id: root

    property var networks: {
        return Networking.devices.values.filter(dev => dev.type !== DeviceType.Wifi).map(dev => ({
                    name: dev.name,
                    state: DeviceConnectionState.toString(dev.state)
                }));
    }

    property var connectedNetwork: {
        return networks.find(net => net.state === "Connected");
    }
}
