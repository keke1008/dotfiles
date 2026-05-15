pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Networking

Singleton {
    id: root

    property var __device: {
        return Networking.devices.values.filter(dev => dev.type !== DeviceType.Wifi);
    }

    property var networks: {
        return root.__device.map(dev => ({
                    name: dev.name,
                    state: ConnectionState.toString(dev.state)
                }));
    }

    property var connectedNetwork: {
        return networks.find(net => net.state === "Connected");
    }
}
