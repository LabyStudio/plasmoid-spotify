import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property bool cfg_showLyricsDefault: true
    property bool cfg_highlightCurrentLineDefault: false
    property bool cfg_showAlbumCoverDefault: true
    property bool cfg_fetchAlbumCoverHttpsDefault: false
    property int cfg_maxTitleArtistLengthDefault: 30

    property alias cfg_showLyrics: showLyrics.checked
    property alias cfg_highlightCurrentLine: highlightCurrentLine.checked
    property alias cfg_showAlbumCover: showAlbumCover.checked
    property alias cfg_fetchAlbumCoverHttps: fetchAlbumCoverHttps.checked
    property alias cfg_maxTitleArtistLength: maxTitleArtistLength.value
    
    // Lyrics font properties
    property alias cfg_lyricsFontSize: lyricsFontSize.value
    property alias cfg_lyricsFontFamily: lyricsFontFamily.currentText
    
    // Title font properties
    property alias cfg_titleFontSize: titleFontSize.value
    property alias cfg_titleFontFamily: titleFontFamily.currentText
    
    // Artist font properties
    property alias cfg_artistFontSize: artistFontSize.value
    property alias cfg_artistFontFamily: artistFontFamily.currentText

    ColumnLayout {
        spacing: Kirigami.Units.smallSpacing

        Kirigami.Heading {
            text: "Lyrics"
            level: 3
            Layout.alignment: Qt.AlignLeft
        }

        CheckBox {
            id: showLyrics
            text: "Show lyrics"
            checked: default_showLyrics
            Layout.alignment: Qt.AlignLeft
        }

        CheckBox {
            id: highlightCurrentLine
            text: "Highlight current line"
            checked: default_highlightCurrentLine
            Layout.alignment: Qt.AlignLeft
        }

        Kirigami.Heading {
            text: "Track Information"
            level: 3
            Layout.alignment: Qt.AlignLeft
            Layout.topMargin: Kirigami.Units.largeSpacing
        }

        CheckBox {
            id: showAlbumCover
            text: "Show album cover"
            checked: default_showAlbumCover
            Layout.alignment: Qt.AlignLeft
        }

        RowLayout {
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: Kirigami.Units.largeSpacing
            spacing: Kirigami.Units.smallSpacing

            CheckBox {
                id: fetchAlbumCoverHttps
                text: "Fetch album cover over HTTPS (Causes issues)"
                checked: default_fetchAlbumCoverHttps
                ToolTip.text: "Use HTTPS to fetch album covers. This could cause issues with the current KDE Plasma version."
                Layout.alignment: Qt.AlignLeft
                enabled: showAlbumCover.checked
                Layout.leftMargin: Kirigami.Units.largeSpacing
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: Kirigami.Units.largeSpacing
            spacing: Kirigami.Units.smallSpacing

            Label {
                text: "Max title/artist length:"
                Layout.alignment: Qt.AlignLeft
            }

            SpinBox {
                id: maxTitleArtistLength
                from: 10
                to: 200
                stepSize: 1
                value: default_maxTitleArtistLength
                Layout.alignment: Qt.AlignLeft
                enabled: showAlbumCover.checked
            }
        }

        // Lyrics Font Settings
        Kirigami.Heading {
            text: "Lyrics Font"
            level: 3
            Layout.alignment: Qt.AlignLeft
            Layout.topMargin: Kirigami.Units.largeSpacing
        }

        RowLayout {
            Layout.alignment: Qt.AlignLeft
            spacing: Kirigami.Units.smallSpacing

            Label {
                text: "Font size (-1 = default):"
                Layout.alignment: Qt.AlignLeft
            }

            SpinBox {
                id: lyricsFontSize
                from: -1
                to: 72
                stepSize: 1
                value: -1
                Layout.alignment: Qt.AlignLeft
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignLeft
            spacing: Kirigami.Units.smallSpacing

            Label {
                text: "Font family:"
                Layout.alignment: Qt.AlignLeft
            }

            ComboBox {
                id: lyricsFontFamily
                model: Qt.fontFamilies()
                editable: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
            }
        }

        // Title Font Settings
        Kirigami.Heading {
            text: "Title Font"
            level: 3
            Layout.alignment: Qt.AlignLeft
            Layout.topMargin: Kirigami.Units.largeSpacing
        }

        RowLayout {
            Layout.alignment: Qt.AlignLeft
            spacing: Kirigami.Units.smallSpacing

            Label {
                text: "Font size (-1 = default):"
                Layout.alignment: Qt.AlignLeft
            }

            SpinBox {
                id: titleFontSize
                from: -1
                to: 72
                stepSize: 1
                value: -1
                Layout.alignment: Qt.AlignLeft
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignLeft
            spacing: Kirigami.Units.smallSpacing

            Label {
                text: "Font family:"
                Layout.alignment: Qt.AlignLeft
            }

            ComboBox {
                id: titleFontFamily
                model: Qt.fontFamilies()
                editable: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
            }
        }

        // Artist Font Settings
        Kirigami.Heading {
            text: "Artist Font"
            level: 3
            Layout.alignment: Qt.AlignLeft
            Layout.topMargin: Kirigami.Units.largeSpacing
        }

        RowLayout {
            Layout.alignment: Qt.AlignLeft
            spacing: Kirigami.Units.smallSpacing

            Label {
                text: "Font size (-1 = default):"
                Layout.alignment: Qt.AlignLeft
            }

            SpinBox {
                id: artistFontSize
                from: -1
                to: 72
                stepSize: 1
                value: -1
                Layout.alignment: Qt.AlignLeft
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignLeft
            spacing: Kirigami.Units.smallSpacing

            Label {
                text: "Font family:"
                Layout.alignment: Qt.AlignLeft
            }

            ComboBox {
                id: artistFontFamily
                model: Qt.fontFamilies()
                editable: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
            }
        }
    }
}