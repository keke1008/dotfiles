pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Bluetooth

Singleton {
    id: root

    property var __adapter: Bluetooth.defaultAdapter

    property bool enabled: __adapter?.enabled === true
    property var adapter: __adapter && ({
            name: __adapter.name,
            enabled: __adapter.enabled
        })

    function __optimisticallyConnected(dev) {
        return [BluetoothDeviceState.Connecting, BluetoothDeviceState.Connected].includes(dev.state);
    }

    function __stateUpdating(dev) {
        return [BluetoothDeviceState.Connecting, BluetoothDeviceState.Disconnecting].includes(dev.state);
    }

    property var devices: __adapter?.devices.values.map(dev => ({
                name: dev.name,
                address: dev.address,
                battery: dev.batteryAvailable ? dev.battery : undefined,
                paired: dev.paired,
                connected: dev.connected,
                state: BluetoothDeviceState.toString(dev.state),
                optimisticallyConnected: __optimisticallyConnected(dev),
                stateUpdating: __stateUpdating(dev)
            }))

    function toggleEnabled() {
        __adapter && (__adapter.enabled = !__adapter.enabled);
    }

    function toggleConnection(address) {
        const dev = __adapter?.devices.values.find(dev => dev.address === address);
        if (!dev || this.__stateUpdating(dev)) {
            return;
        }

        if (dev.connected) {
            dev.disconnect();
        } else {
            dev.connect();
        }
    }
}
