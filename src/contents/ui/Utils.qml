// noinspection UnnecessaryReturnStatementJS

import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid

Item {
    function fetch(url) {
        let xhr = new XMLHttpRequest();
        xhr.open("GET", url, true);
        xhr.send();

        console.debug("Fetching " + url);

        return new Promise((resolve, reject) => {
            xhr.onreadystatechange = () => {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        resolve({
                            json: () => JSON.parse(xhr.responseText),
                            text: () => xhr.responseText
                        });
                    } else {
                        reject({
                            status: xhr.status,
                            statusText: xhr.statusText
                        });
                    }
                }
            };
        });
    }

    function parseLyrics(text) {
        let lines = text.split("\n");
        let lyrics = [];

        for (let i = 0; i < lines.length; i++) {
            let line = lines[i];
            let match = line.match(/\[(\d+):(\d+\.\d+)\](.*)/);

            if (match) {
                let minutes = parseInt(match[1]);
                let seconds = parseFloat(match[2]);
                let text = match[3];

                lyrics.push({
                    time: minutes * 60 + seconds,
                    text: text
                });
            }
        }

        console.log("Parsed " + lyrics.length + " lines of lyrics");

        return lyrics;
    }
}