import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid

Text {
    id: textElement
    Layout.fillWidth: true
    Layout.preferredHeight: parent.height
    Layout.rightMargin: 15
    Layout.leftMargin: 15
    wrapMode: Text.NoWrap
    horizontalAlignment: Text.AlignRight
    textFormat: Text.RichText

    text: "Lyrics"
    color: Kirigami.Theme.textColor
    font: Kirigami.Theme.defaultFont
    lineHeight: 0.8

    property var lyrics: null
    property var spotify: null
    property var transitionDuration: 1000
    property var lineCount: 0
    property var renderedLineIndex: -1
    property var renderedHighlighted: false

    onLyricsChanged: {
        if (!plasmoid.configuration.highlightCurrentLine) {
            updateText();
        }
        updateTargetPosition(false)
    }

    Connections {
        target: plasmoid.configuration
        function onLyricsFontSizeChanged() {
            updateFontProperties()
            updateTargetPosition(false)
        }
        function onLyricsFontFamilyChanged() {
            updateFontProperties()
            updateTargetPosition(false)
        }
    }

    Timer {
        interval: 250
        running: spotify.ready && spotify.playing && lyrics !== null
        repeat: true
        onTriggered: {
            updateTargetPosition()
        }
    }

    NumberAnimation on y {
        id: animation
        duration: transitionDuration
        easing.type: Easing.InOutQuad
    }

    function updateText() {
        let builder = "";
        let lines = 0;
        let currentLineIndex = getCurrentLineIndex();
        let highlight = plasmoid.configuration.highlightCurrentLine;

        if (lyrics !== null && lyrics) {
            lyrics.forEach((line, i) => {
                if (i === currentLineIndex || !highlight) {
                    builder += line.text;
                } else {
                    builder += `<span style="color:gray">${line.text}</span>`;
                }

                if (i < lyrics.length - 1) {
                    builder += "<br/>";
                }
                lines++;
            });
        }

        lineCount = lines;
        textElement.text = builder;
        renderedLineIndex = currentLineIndex;
        renderedHighlighted = highlight;
    }

    function updateTargetPosition(animated = true) {
        let currentY = y;

        if (canUpdateText()) {
            updateText();
        }

        if (textElement.parent !== null && lineCount > 0) {
            if (animated) {
                animation.from = currentY;
                animation.to = calculateTargetY();
                animation.start()
            } else {
                animation.stop()
                y = calculateTargetY()
            }
        }
    }

    function canUpdateText() {
        let highlight = plasmoid.configuration.highlightCurrentLine;
        if (renderedHighlighted !== highlight) {
            return true;
        }

        let currentLineIndex = getCurrentLineIndex();
        if (renderedLineIndex === currentLineIndex) {
            return false;
        }

        return highlight;
    }

    function getCurrentLineIndex(offset = 0) {
        if (lyrics === null || lyrics.length === 0) {
            return -1;
        }

        let position = spotify.getDaemonPosition() / 1_000_000 + offset;
        let target = -1;
        for (let i = 0; i < lyrics.length; i++) {
            if (lyrics[i].time <= position) {
                target = i;
            } else {
                break;
            }
        }
        return target;
    }

    function calculateTargetY() {
        let currentLineIndex = getCurrentLineIndex(transitionDuration / 1000 / 2);
        let offsetY = 0;
        let lineHeight = (textElement.contentHeight - 3) / textElement.lineCount;
        if (lyrics !== null && currentLineIndex >= 0) {
            offsetY = lineHeight * (currentLineIndex + 1);
        }
        return textElement.parent.height / 2 - offsetY + lineHeight / 2 - 3;
    }

    function updateFontProperties() {
        let fontObject = Qt.font(textElement.font);
        
        // Apply font size if set
        if (plasmoid.configuration.lyricsFontSize > 0) {
            fontObject.pixelSize = plasmoid.configuration.lyricsFontSize;
        }
        
        // Apply font family if set
        if (plasmoid.configuration.lyricsFontFamily && plasmoid.configuration.lyricsFontFamily.length > 0) {
            fontObject.family = plasmoid.configuration.lyricsFontFamily;
        }
        
        textElement.font = fontObject;
    }

}
