pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    readonly property var players: ScriptModel {
        objectProp: "id"
        values: {
            return Mpris.players.values.map(p => ({
                        id: p.uniqueId,
                        position: p.position,
                        length: p.lengthSupported ? p.length : 1,
                        isPlaying: p.isPlaying,
                        trackTitle: p.trackTitle || "Unknown Title",
                        trackArtist: p.trackArtist || "Unknown Artist",
                        trackArtUrl: p.trackArtUrl
                    })).sort((pa, pb) => pa.uniqueId - pb.uniqueId);
        }
    }

    Timer {
        interval: 1000
        repeat: true
        triggeredOnStart: true
        running: players.values.some(p => p.isPlaying)

        onTriggered: {
            Mpris.players.values.forEach(p => p.positionChanged());
        }
    }

    function __getPlayer(id) {
        const player = Mpris.players.values.find(p => p.uniqueId === id);
        if (player === undefined) {
            console.warn(`Mpris player ${id} does not exist`);
            return;
        }

        return player;
    }

    function togglePlaying(id) {
        const player = root.__getPlayer(id);
        player?.canTogglePlaying && player.togglePlaying();
    }

    function skipNext(id) {
        const player = root.__getPlayer(id);
        player?.canGoNext && player.next();
    }

    function skipPrevious(id) {
        const player = root.__getPlayer(id);
        player?.canGoPrevious && player.previous();
    }
}
