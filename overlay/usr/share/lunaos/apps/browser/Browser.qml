import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtWebEngine 1.10
import LunaOS 1.0

Rectangle {
    id: browser
    width: 1024
    height: 768
    color: "#1e1e2e"
    radius: 8
    border.color: "#89b4fa"
    border.width: 1
    
    property bool isMaximized: false
    property bool isMinimized: false
    property rect restoreGeometry: Qt.rect(x, y, width, height)
    property string windowTitle: "Web Browser"
    property var bookmarks: []
    property var history: []
    
    signal closed()

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Title bar with navigation controls
        Rectangle {
            Layout.fillWidth: true
            height: 32
            color: "#181825"
            radius: 8

            RowLayout {
                anchors.fill: parent
                spacing: 8

                // Navigation buttons
                Row {
                    Layout.leftMargin: 8
                    spacing: 8

                    ToolButton {
                        text: "<"
                        onClicked: webview.goBack()
                        enabled: webview.canGoBack
                    }

                    ToolButton {
                        text: ">"
                        onClicked: webview.goForward()
                        enabled: webview.canGoForward
                    }

                    ToolButton {
                        text: "⟳"
                        onClicked: webview.reload()
                    }
                    ToolButton {
                        text: "☆"
                        onClicked: {
                            var currentUrl = webview.url.toString()
                            if (!bookmarks.includes(currentUrl)) {
                                bookmarks.push(currentUrl)
                            }
                        }
                    }
                }

                // URL bar
                TextField {
                    Layout.fillWidth: true
                    text: webview.url
                    placeholderText: "Enter URL..."
                    onAccepted: {
                        var url = text
                        if (!url.startsWith("http://") && !url.startsWith("https://")) {
                            url = "https://" + url
                        }
                        webview.url = url
                    }
                }

                // Window controls
                Row {
                    Layout.rightMargin: 8
                    spacing: 8

                    Repeater {
                        model: [
                            { color: "#f9e2af", action: "minimize" },
                            { color: "#a6e3a1", action: "maximize" },
                            { color: "#f38ba8", action: "close" }
                        ]

                        Rectangle {
                            width: 12
                            height: 12
                            radius: 6
                            color: modelData.color

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (modelData.action === "close") browser.closed()
                                    else if (modelData.action === "minimize") browser.minimize()
                                    else if (modelData.action === "maximize") browser.toggleMaximize()
                                }
                            }
                        }
                    }
                }
            }
        }

        // Web view
        WebEngineView {
            id: webview
            Layout.fillWidth: true
            Layout.fillHeight: true
            url: "https://google.com"
            
            onLoadingChanged: function(loadRequest) {
                if (loadRequest.status === WebEngineLoadRequest.LoadSucceededStatus) {
                    var currentUrl = url.toString()
                    if (!history.includes(currentUrl)) {
                        history.push(currentUrl)
                    }
                }
            }

            settings.javascriptEnabled: true
            settings.pluginsEnabled: true
            settings.fullScreenSupportEnabled: true
            settings.autoLoadImages: true
            settings.javascriptCanOpenWindows: true
        }
    }

    // Add window management functions similar to your other apps
    function toggleMaximize() {
        if (isMaximized) {
            x = restoreGeometry.x
            y = restoreGeometry.y
            width = restoreGeometry.width
            height = restoreGeometry.height
        } else {
            restoreGeometry = Qt.rect(x, y, width, height)
            var parentItem = parent || Qt.application.screens[0]
            x = 0
            y = 0
            width = parentItem.width
            height = parentItem.height
        }
        isMaximized = !isMaximized
    }

    function minimize() {
        if (!isMinimized) {
            // Store current state before minimizing
            restoreGeometry = Qt.rect(x, y, width, height)
            isMinimized = true
            visible = false
        }
    }

    function restore() {
        if (isMinimized) {
            // Restore from minimized state
            visible = true
            x = restoreGeometry.x
            y = restoreGeometry.y
            width = restoreGeometry.width
            height = restoreGeometry.height
            isMinimized = false
        }
    }
}