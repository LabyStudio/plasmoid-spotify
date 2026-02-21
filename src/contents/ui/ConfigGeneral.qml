import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property bool cfg_showLyricsDefault
    property bool cfg_highlightCurrentLineDefault
    property int cfg_lyricsFontSizeDefault
    property bool cfg_alternativeLineHeightCalculationDefault
    property string cfg_lyricsFontFamilyDefault

    property bool cfg_showAlbumCoverDefault
    property bool cfg_fetchAlbumCoverHttpsDefault
    property int cfg_maxTitleArtistLengthDefault
    property bool cfg_showTitleDefault
    property int cfg_titleFontSizeDefault
    property string cfg_titleFontFamilyDefault
    property bool cfg_showArtistDefault
    property int cfg_artistFontSizeDefault
    property string cfg_artistFontFamilyDefault

    property alias cfg_transparentBackground: transparentBackground.checked

    property alias cfg_showLyrics: showLyrics.checked
    property alias cfg_highlightCurrentLine: highlightCurrentLine.checked
    property alias cfg_lyricsFontSize: lyricsFontSize.value
    property alias cfg_alternativeLineHeightCalculation: alternativeLineHeightCalculation.checked
    property alias cfg_lyricsFontFamily: lyricsFontFamily.currentText

    property bool cfg_useCustomLyricsColorDefault
    property alias cfg_useCustomLyricsColor: useCustomLyricsColor.checked
    property string cfg_lyricsTextColor: plasmoid.configuration.lyricsTextColor

    property alias cfg_showAlbumCover: showAlbumCover.checked
    property alias cfg_fetchAlbumCoverHttps: fetchAlbumCoverHttps.checked
    property alias cfg_maxTitleArtistLength: maxTitleArtistLength.value
    property alias cfg_showTitle: showTitle.checked
    property alias cfg_titleFontSize: titleFontSize.value
    property alias cfg_titleFontFamily: titleFontFamily.currentText
    property bool cfg_useCustomTitleColorDefault
    property alias cfg_useCustomTitleColor: useCustomTitleColor.checked
    property string cfg_titleTextColor: plasmoid.configuration.titleTextColor
    property alias cfg_showArtist: showArtist.checked
    property alias cfg_artistFontSize: artistFontSize.value
    property alias cfg_artistFontFamily: artistFontFamily.currentText
    property bool cfg_useCustomArtistColorDefault
    property alias cfg_useCustomArtistColor: useCustomArtistColor.checked
    property string cfg_artistTextColor: plasmoid.configuration.artistTextColor

    ColumnLayout {
        spacing: Kirigami.Units.smallSpacing

        Kirigami.Heading {
            text: "Appearance"
            level: 3
            Layout.alignment: Qt.AlignLeft
            Layout.topMargin: Kirigami.Units.largeSpacing
        }

        CheckBox {
            id: transparentBackground
            text: "Transparent background"
            ToolTip.text: "Use transparent background when plasmoid is on desktop (not in panel)"
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: Kirigami.Units.largeSpacing
        }

        // Spacer
        Rectangle {
            Layout.fillWidth: true
            height: 20
            color: "transparent"
        }

        Kirigami.Heading {
            text: "Lyrics"
            level: 3
            Layout.alignment: Qt.AlignLeft
        }

        CheckBox {
            id: showLyrics
            text: "Show lyrics"
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: Kirigami.Units.largeSpacing
        }

        CheckBox {
            id: highlightCurrentLine
            text: "Highlight current line"
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 20
            enabled: showLyrics.checked
        }

        CheckBox {
            id: alternativeLineHeightCalculation
            text: "Use alternative scroll offset calculation (Works better with some fonts)"
            ToolTip.text: "Use an alternative method to calculate line height which may work better with some fonts."
            Layout.alignment: Qt.AlignLeft
            enabled: showLyrics.checked
            Layout.leftMargin: 20
        }

        RowLayout {
            Layout.alignment: Qt.AlignLeft
            spacing: Kirigami.Units.smallSpacing
            Layout.leftMargin: 20
            enabled: showLyrics.checked

            Label {
                text: "Lyrics Font:"
                Layout.alignment: Qt.AlignLeft
            }

            ComboBox {
                id: lyricsFontFamily
                model: Qt.fontFamilies()
                editable: true
                Layout.alignment: Qt.AlignLeft

                Component.onCompleted: {
                    const index = model.indexOf(plasmoid.configuration.lyricsFontFamily)
                    currentIndex = index >= 0 ? index : 0
                }
            }

            SpinBox {
                id: lyricsFontSize
                from: 8
                to: 72
                stepSize: 1
                Layout.alignment: Qt.AlignLeft
            }
        }

        CheckBox {
            id: useCustomLyricsColor
            text: "Use custom lyrics text color"
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 20
            enabled: showLyrics.checked
        }

        RowLayout {
            Layout.alignment: Qt.AlignLeft
            spacing: Kirigami.Units.smallSpacing
            Layout.leftMargin: 40
            enabled: showLyrics.checked && useCustomLyricsColor.checked

            Label {
                text: "Lyrics Color:"
                Layout.alignment: Qt.AlignLeft
            }

            Rectangle {
                width: 40
                height: 24
                radius: 4
                color: cfg_lyricsTextColor
                border.color: Kirigami.Theme.textColor
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: lyricsColorDialog.open()
                }
            }

            Label {
                text: cfg_lyricsTextColor
                Layout.alignment: Qt.AlignLeft
                opacity: 0.7
            }
        }

        ColorDialog {
            id: lyricsColorDialog
            title: "Choose lyrics text color"
            selectedColor: cfg_lyricsTextColor
            onAccepted: {
                cfg_lyricsTextColor = selectedColor.toString()
            }
        }

        // Spacer
        Rectangle {
            Layout.fillWidth: true
            height: 20
            color: "transparent"
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
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: Kirigami.Units.largeSpacing
        }

        RowLayout {
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: Kirigami.Units.largeSpacing
            spacing: Kirigami.Units.smallSpacing

            CheckBox {
                id: fetchAlbumCoverHttps
                text: "Fetch album cover over HTTPS (Causes issues)"
                ToolTip.text: "Use HTTPS to fetch album covers. This could cause issues with the current KDE Plasma version."
                Layout.alignment: Qt.AlignLeft
                enabled: showAlbumCover.checked
                Layout.leftMargin: 20
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
                Layout.alignment: Qt.AlignLeft
                enabled: showAlbumCover.checked
            }
        }

        CheckBox {
            id: showTitle
            text: "Show title"
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: Kirigami.Units.largeSpacing
            checked: plasmoid.configuration.showTitle
            onCheckedChanged: plasmoid.configuration.showTitle = checked
        }

        RowLayout {
            Layout.alignment: Qt.AlignLeft
            spacing: Kirigami.Units.smallSpacing
            Layout.leftMargin: Kirigami.Units.largeSpacing

            Label {
                text: "Title Font:"
                Layout.alignment: Qt.AlignLeft
            }

            ComboBox {
                id: titleFontFamily
                model: Qt.fontFamilies()
                editable: true
                Layout.alignment: Qt.AlignLeft

                Component.onCompleted: {
                    const index = model.indexOf(plasmoid.configuration.titleFontFamily)
                    currentIndex = index >= 0 ? index : 0
                }
            }

            SpinBox {
                id: titleFontSize
                from: 8
                to: 72
                stepSize: 1
                Layout.alignment: Qt.AlignLeft
            }
        }

        CheckBox {
            id: useCustomTitleColor
            text: "Use custom title text color"
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 20
            enabled: showTitle.checked
        }

        RowLayout {
            Layout.alignment: Qt.AlignLeft
            spacing: Kirigami.Units.smallSpacing
            Layout.leftMargin: 40
            enabled: showTitle.checked && useCustomTitleColor.checked

            Label {
                text: "Title Color:"
                Layout.alignment: Qt.AlignLeft
            }

            Rectangle {
                width: 40
                height: 24
                radius: 4
                color: cfg_titleTextColor
                border.color: Kirigami.Theme.textColor
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: titleColorDialog.open()
                }
            }

            Label {
                text: cfg_titleTextColor
                Layout.alignment: Qt.AlignLeft
                opacity: 0.7
            }
        }

        ColorDialog {
            id: titleColorDialog
            title: "Choose title text color"
            selectedColor: cfg_titleTextColor
            onAccepted: {
                cfg_titleTextColor = selectedColor.toString()
            }
        }

        CheckBox {
            id: showArtist
            text: "Show artist"
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: Kirigami.Units.largeSpacing
            checked: plasmoid.configuration.showArtist
            onCheckedChanged: plasmoid.configuration.showArtist = checked
        }

        RowLayout {
            Layout.alignment: Qt.AlignLeft
            spacing: Kirigami.Units.smallSpacing
            Layout.leftMargin: Kirigami.Units.largeSpacing

            Label {
                text: "Artist Font:"
                Layout.alignment: Qt.AlignLeft
            }

            ComboBox {
                id: artistFontFamily
                model: Qt.fontFamilies()
                editable: true
                Layout.alignment: Qt.AlignLeft

                Component.onCompleted: {
                    const index = model.indexOf(plasmoid.configuration.artistFontFamily)
                    currentIndex = index >= 0 ? index : 0
                }
            }

            SpinBox {
                id: artistFontSize
                from: 8
                to: 72
                stepSize: 1
                Layout.alignment: Qt.AlignLeft
            }
        }

        CheckBox {
            id: useCustomArtistColor
            text: "Use custom artist text color"
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 20
            enabled: showArtist.checked
        }

        RowLayout {
            Layout.alignment: Qt.AlignLeft
            spacing: Kirigami.Units.smallSpacing
            Layout.leftMargin: 40
            enabled: showArtist.checked && useCustomArtistColor.checked

            Label {
                text: "Artist Color:"
                Layout.alignment: Qt.AlignLeft
            }

            Rectangle {
                width: 40
                height: 24
                radius: 4
                color: cfg_artistTextColor
                border.color: Kirigami.Theme.textColor
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: artistColorDialog.open()
                }
            }

            Label {
                text: cfg_artistTextColor
                Layout.alignment: Qt.AlignLeft
                opacity: 0.7
            }
        }

        ColorDialog {
            id: artistColorDialog
            title: "Choose artist text color"
            selectedColor: cfg_artistTextColor
            onAccepted: {
                cfg_artistTextColor = selectedColor.toString()
            }
        }
    }
}