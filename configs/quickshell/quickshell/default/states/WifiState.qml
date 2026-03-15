pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Networking

Singleton {
    id: root

    property var __device: {
        return Networking.devices.values.filter(dev => dev.type == DeviceType.Wifi)[0];
    }

    property var networks: {
        return __device?.networks.values.map(net => ({
                    name: net.name,
                    state: NetworkState.toString(net.state),
                    strength: net.signalStrength,
                    known: net.known
                })) ?? [];
    }

    property var connectedNetwork: {
        return networks.find(net => net.state === "Connected");
    }

    property bool enabled: Networking.wifiEnabled
    function toggleEnabled() {
        Networking.wifiEnabled = !Networking.wifiEnabled;
    }
}
