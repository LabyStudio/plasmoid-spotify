// noinspection UnnecessaryReturnStatementJS

import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid

Item {
    required property var cache

    Utils {
        id: utils
    }

    readonly property string endpoint: "https://lrclib.net"
    readonly property string url_search: endpoint + "/api/search"

    function fetchLyrics(trackName, artistName, albumName) {
        const key = JSON.stringify([trackName, artistName, albumName])
        const cached = cache.get("lyrics", key)
        if (cached !== null) {
            try {
                return Promise.resolve(JSON.parse(cached))
            } catch (error) {
                cache.remove("lyrics", key)
            }
        }

        return search(trackName, artistName, albumName)
            .then(data => {
            if (data.length <= 0) {
                console.debug("No results found for", trackName, artistName, albumName);
                return null;
            }

            let text = null;
            for (let i = 0; i < data.length; i++) {
                if (!data[i].syncedLyrics) {
                    continue;
                }
                text = data[i].syncedLyrics;
                break;
            }

            if (!text) {
                console.debug("No synced lyrics found in any result");
                return null;
            }

            return utils.parseLyrics(text);
        }).then(lyrics => {
            cache.put("lyrics", key, JSON.stringify(lyrics))
            return lyrics
        })
    }

    function search(trackName, artistName, albumName) {
        return searchByTrack(trackName, artistName, albumName)
            .then(data => {
            if (data.length > 0) {
                return data;
            }
            return searchByString(trackName + " " + artistName)
                .then(data2 => {
                if (data2.length > 0) {
                    return data2;
                }
                return searchByString(trackName)
                    .then(data3 => {
                    if (data3.length > 0) {
                        // Remove all entries with wrong artist
                        data3 = data3.filter(item => {
                            return item.artistName.toLowerCase() === artistName.toLowerCase();
                        });
                        return data3;
                    }
                    return [];
                });
            });
        });
    }

    function searchByTrack(trackName, artistName, albumName) {
        let url = url_search
            + "?track_name=" + encodeURIComponent(trackName)
            + "&artist_name=" + encodeURIComponent(artistName)
            + "&album_name=" + encodeURIComponent(albumName);

        return utils.fetch(url)
            .then(response => response.json());
    }

    function searchByString(query) {
        let url = url_search + "?q=" + encodeURIComponent(query);

        return utils.fetch(url)
            .then(response => response.json());
    }

}
