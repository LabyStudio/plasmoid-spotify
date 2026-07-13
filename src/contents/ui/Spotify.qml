import QtQuick 2.15
import QtQml.Models 2.3
import org.kde.plasma.plasmoid
import org.kde.plasma.private.mpris as Mpris

QtObject {
    id: root

    readonly property string playerIdentity: {
        const configuredIdentity = plasmoid.configuration.playerIdentity
        if (configuredIdentity === undefined || configuredIdentity === null) {
            return "Spotify"
        }
        return configuredIdentity.trim()
    }

    readonly property bool acceptAnyPlayer: playerIdentity.length === 0

    property var mpris2Model: Mpris.Mpris2Model
    {
        readonly property int containerRole: Qt.UserRole + 1

        function isConfiguredPlayer(rowIndex) {
            const player = this.data(this.index(rowIndex, 0), containerRole)
            return !!(player && (root.acceptAnyPlayer || player.identity === root.playerIdentity));
        }

        function selectConfiguredPlayer() {
            for (let i = 0; i < this.rowCount(); i++) {
                if (isConfiguredPlayer(i)) {
                    this.currentIndex = i;
                    break;
                }
            }
        }

        onRowsInserted: (_, rowIndex) => {
            // Check if the inserted row is the configured player
            if (isConfiguredPlayer(rowIndex)) {
                this.currentIndex = rowIndex;
            }
        }

        Component.onCompleted: {
            selectConfiguredPlayer()
        }
    }

    onPlayerIdentityChanged: mpris2Model.selectConfiguredPlayer()

    readonly property var player: {
        return mpris2Model.currentPlayer
    }

    readonly property bool ready: {
        return player && (acceptAnyPlayer || player.identity === playerIdentity)
    }

    readonly property string identity: ready ? normalizedMetadata(player.identity) : null
    readonly property string track: ready ? normalizedMetadata(player.track) : null
    readonly property string artist: ready ? normalizedMetadata(player.artist) : null
    readonly property string album: ready ? normalizedMetadata(player.album) : null

    readonly property double position: ready ? player.position : 0
    readonly property double length: ready ? player.length : 0

    readonly property bool playing: ready ? player.playbackStatus === Mpris.PlaybackStatus.Playing : false

    readonly property string artworkUrl: ready ? player.artUrl : null

    readonly property bool canRaise: ready ? player.canRaise : false

    property var timeLastPositionChanged: new Date().getTime()

    function getDaemonPosition() {
        let timePassed = new Date().getTime() - timeLastPositionChanged
        return position + (playing ? (timePassed * 1_000) : 0)
    }

    onPositionChanged: {
        timeLastPositionChanged = new Date().getTime()
    }

    onTrackChanged: {
        timeLastPositionChanged = new Date().getTime()
    }

    onPlayingChanged: {
        timeLastPositionChanged = new Date().getTime()
    }

    function raise() {
        if (ready) {
            player.Raise()
        }
    }

    function togglePlayback() {
        if (ready) {
            player.PlayPause()
        }
    }

    function changeVolume(delta, showOSD) {
        if (ready) {
            player.changeVolume(delta, showOSD);
        }
    }

    function normalizedMetadata(value) {
        if (value === undefined || value === null) {
            return null
        }

        if (Array.isArray(value)) {
            value = value.join(", ")
        }

        const text = String(value).replace(/\s+/g, " ").trim()
        return text.length > 0 ? text : null
    }

}
