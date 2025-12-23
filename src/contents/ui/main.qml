import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import Qt5Compat.GraphicalEffects
import org.kde.plasma.core as PlasmaCore

PlasmoidItem {
    id: widget

    Plasmoid.status: PlasmaCore.Types.HiddenStatus

    Layout.preferredWidth: row.implicitWidth
    Layout.preferredHeight: row.implicitHeight

    readonly property int volumeStep: 2

    /* Lyrics LRC library */
    LyricsLrcLib {
        id: lyricsLrcLib
    }

    /* Spotify player */
    Spotify {
        id: spotify

        onReadyChanged: {
            Plasmoid.status = spotify.ready ? PlasmaCore.Types.ActiveStatus : PlasmaCore.Types.HiddenStatus
        }

        onPositionChanged: {
            if (spotify.ready) {
                updateProgressIndicator()
            }
        }

        onArtworkUrlChanged: {
            if (spotify.ready) {
                let url = spotify.artworkUrl;
                if (url && url.startsWith("https://") && !plasmoid.configuration.fetchAlbumCoverHttps) {
                    url = url.replace("https://", "http://");
                }
                artwork.source = url || artwork.fallbackSource;

                lyricsRenderer.lyrics = null;
                lyricsLrcLib.fetchLyrics(spotify.track, spotify.artist, spotify.album).then(lyrics => {
                    lyricsRenderer.lyrics = lyrics;
                })
            }
        }
    }

    /* Progress bar updater */
    Timer {
        id: timer
        interval: 1000;
        running: spotify && spotify.playing;
        repeat: true
        onTriggered: () => {
            updateProgressIndicator()
        }
    }

    /* Mouse click handling */
    MouseArea {
        z: 100
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        cursorShape: spotify && spotify.canRaise ? Qt.PointingHandCursor : Qt.ArrowCursor
        hoverEnabled: true

        onClicked: (mouse) => {
            switch (mouse.button) {
                case Qt.MiddleButton:
                    spotify.togglePlayback()
                    break
                case Qt.LeftButton:
                    if (spotify.canRaise) {
                        spotify.raise()
                    }
                    break
            }
        }

        onWheel: (wheel) => {
            if (wheel.angleDelta.y > 0) {
                spotify.changeVolume(volumeStep / 100, true)
            } else {
                spotify.changeVolume(-volumeStep / 100, true)
            }
        }
    }

    RowLayout {
        id: row
        anchors.fill: parent
        spacing: 0
        clip: true

        LyricsRenderer {
            id: lyricsRenderer
            lyrics: null
            spotify: spotify
            visible: plasmoid.configuration.showLyrics && spotify && spotify.ready && lyrics && lyrics.length > 0
            Layout.fillWidth: true
            centeredLyrics: !plasmoid.configuration.showAlbumCover
                && !plasmoid.configuration.showTitle
                && !plasmoid.configuration.showArtist
        }

        /* Album artwork */
        Image {
            id: artwork

            Layout.preferredWidth: parent.height
            Layout.preferredHeight: parent.height
            Layout.rightMargin: 5
            Layout.fillWidth: false
            fillMode: Image.PreserveAspectFit


            property string fallbackSource: "../assets/icon.svg"
            property string lastAttemptedSource: ""

            source: artwork.fallbackSource
            visible: plasmoid.configuration.showAlbumCover

            Timer {
                id: fallbackTimer
                interval: 5000
                repeat: false
                onTriggered: {
                    console.warn("Failed to load artwork from", artwork.lastAttemptedSource)
                    artwork.source = artwork.fallbackSource
                }
            }

            onSourceChanged: {
                if (source === fallbackSource) {
                    fallbackTimer.stop()
                } else {
                    fallbackTimer.restart()
                    lastAttemptedSource = source
                }
            }

            onStatusChanged: {
                switch (status) {
                    case Image.Ready:
                        fallbackTimer.stop()
                        break
                }
            }

            /* Border radius */
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Item {
                    width: artwork.width
                    height: artwork.height
                    Rectangle {
                        anchors.fill: parent
                        radius: 8
                    }
                }
            }

            /* Progress bar */
            Rectangle {
                id: progress
                visible: spotify && spotify.ready

                x: 2
                height: 3
                width: artwork.width - 4
                anchors.bottom: parent.bottom
                color: "#282828"

                Rectangle {
                    id: progressIndicator
                    anchors.bottom: parent.bottom
                    height: 2
                    width: 0
                    color: "#1db954"
                }
            }
        }

        /* Song information */
        Item {
            Layout.preferredWidth: column.implicitWidth
            Layout.preferredHeight: column.implicitHeight
            Layout.fillWidth: true
            visible: plasmoid.configuration.showTitle || plasmoid.configuration.showArtist

            ColumnLayout {
                id: column
                anchors.fill: parent
                spacing: 0

                /* Song title */
                Text {
                    id: title
                    wrapMode: Text.NoWrap
                    lineHeightMode: Text.FixedHeight
                    Layout.fillWidth: true
                    Layout.rightMargin: 20

                    color: Kirigami.Theme.textColor
                    font.pixelSize: plasmoid.configuration.titleFontSize
                    font.family: plasmoid.configuration.titleFontFamily
                    font.weight: Font.Bold
                    text: spotify && spotify.ready ? truncateText(spotify.track, plasmoid.configuration.maxTitleArtistLength) : "Spotify"

                    Layout.preferredHeight: title.font.pixelSize + 4
                    visible: plasmoid.configuration.showTitle
                }

                /* Artist name */
                Text {
                    id: artist
                    wrapMode: Text.NoWrap
                    lineHeightMode: Text.FixedHeight
                    Layout.fillWidth: true
                    Layout.rightMargin: 20

                    color: Kirigami.Theme.textColor
                    font.pixelSize: plasmoid.configuration.artistFontSize
                    font.family: plasmoid.configuration.artistFontFamily
                    text: spotify && spotify.ready ? truncateText(spotify.artist, plasmoid.configuration.maxTitleArtistLength) : "No song playing"

                    Layout.preferredHeight: artist.font.pixelSize + 4
                    visible: plasmoid.configuration.showArtist
                }
            }
        }
    }

    function updateProgressIndicator() {
        if (spotify.ready) {
            progressIndicator.width = Math.min(1, (spotify.getDaemonPosition() / spotify.length)) * progress.width
        }
    }

    function truncateText(text, maxLen) {
        return text && text.length > maxLen
            ? text.slice(0, maxLen - 3) + "..."
            : text;
    }
}
