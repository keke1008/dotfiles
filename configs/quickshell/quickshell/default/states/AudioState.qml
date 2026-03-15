pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    PwObjectTracker {
        id: hardwareNodesTracker
        objects: Pipewire.nodes.values.filter(node => !node.isStream && node.audio)
    }

    function __getAudioNode(nodeId) {
        const node = hardwareNodesTracker.objects.find(node => node.id === nodeId);
        if (node === undefined) {
            console.warn(`PipeWire Node ${nodeId} does not exist`);
            return undefined;
        }

        const audio = node.audio;
        if (!audio) {
            console.warn(`PipWire Node ${nodeId} is not audio node`);
            return undefined;
        }

        return node;
    }

    // { id, name: string, volume: string, muted: boolean, default: boolean }[]
    property var sinks: {
        const defaultSinkId = Pipewire.defaultAudioSink?.id;

        return hardwareNodesTracker.objects.filter(node => node.isSink).map(node => ({
                    id: node.id,
                    name: node.nickname || node.description,
                    type: node.type,
                    volume: node.audio.volume,
                    muted: node.audio.muted,
                    default: node.id === defaultSinkId
                })).sort((a, b) => a.id - b.id);
    }

    property var defaultSink: {
        return sinks.find(sink => sink.default);
    }

    function setDefaultSink(nodeId) {
        const node = root.__getAudioNode(nodeId);
        if (node !== undefined) {
            Pipewire.preferredDefaultAudioSink = node;
        }
    }

    // { id, name: string, volume: string, muted: boolean, default: boolean }[]
    property var sources: {
        const defaultSourceId = Pipewire.defaultAudioSource?.id;

        return hardwareNodesTracker.objects.filter(node => !node.isSink).map(node => ({
                    id: node.id,
                    name: node.nickname || node.description,
                    type: node.type,
                    volume: node.audio.volume,
                    muted: node.audio.muted,
                    default: node.id === defaultSourceId
                })).sort((a, b) => b.id - a.id);
    }

    property var defaultSource: {
        return sources.find(source => source.default);
    }

    function setDefaultSource(nodeId) {
        const node = root.__getAudioNode(nodeId);
        if (node !== undefined) {
            Pipewire.preferredDefaultAudioSource = node;
        }
    }

    function setVolume(nodeId, volume) {
        const node = root.__getAudioNode(nodeId);
        if (node !== undefined) {
            node.audio.volume = volume;
        }
    }

    function setMute(nodeId, muted) {
        const node = root.__getAudioNode(nodeId);
        if (node !== undefined) {
            node.audio.muted = muted;
        }
    }
}
