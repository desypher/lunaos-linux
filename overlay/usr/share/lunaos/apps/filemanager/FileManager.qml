import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import LunaOS 1.0

Rectangle {
    id: fileManager
    width: 800
    height: 500
    color: "#1e1e2e"
    radius: 8
    border.color: "#fab387"
    border.width: 1
    visible: true
    

    property bool isMaximized: false
    property bool isMinimized: false
    property rect restoreGeometry: Qt.rect(x, y, width, height)

    FileManagerBackend {
        id: backend
        onError: console.error(message)
    }

    // Title Bar
    Rectangle {
        id: titleBar
        height: 32
        color: "#181825"
        radius: 8
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        // Window Title
        Text {
            text: "File Manager - " + backend.currentPath
            color: "#cdd6f4"
            font.pixelSize: 12
            anchors.centerIn: parent
        }

        // Window Controls
        Row {
            anchors {
                right: parent.right
                rightMargin: 8
                verticalCenter: parent.verticalCenter
            }
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
                            if (modelData.action === "close") fileManager.destroy()
                            else if (modelData.action === "minimize") fileManager.showMinimized()
                            else if (modelData.action === "maximize") fileManager.toggleMaximize()
                        }
                    }
                }
            }
        }

        // Drag Area
        MouseArea {
            anchors.fill: parent
            property point clickPos: "0,0"
            onPressed: clickPos = Qt.point(mouse.x, mouse.y)
            onPositionChanged: {
                var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                fileManager.x += delta.x
                fileManager.y += delta.y
            }
        }
    }

    // Navigation Bar
    Rectangle {
        id: navBar
        height: 40
        color: "#313244"
        anchors {
            top: titleBar.bottom
            left: parent.left
            right: parent.right
        }

        RowLayout {
            anchors {
                fill: parent
                margins: 8
            }
            spacing: 8

            // Navigation Buttons
            Repeater {
                model: [
                    { icon: "←", action: "back" },
                    { icon: "→", action: "forward" },
                    { icon: "↑", action: "up" }
                ]

                Button {
                    width: 32
                    height: 32
                    text: modelData.icon
                    
                    contentItem: Text {
                        text: modelData.icon
                        color: "#cdd6f4"
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        radius: 4
                        color: parent.pressed ? "#45475a" : (parent.hovered ? "#585b70" : "transparent")
                    }

                    onClicked: {
                        if (modelData.action === "up") {
                            backend.setCurrentPath(backend.getParentPath())
                        }
                    }
                }
            }

            // Path TextField
            TextField {
                Layout.fillWidth: true
                text: backend.currentPath
                color: "#cdd6f4"
                font.pixelSize: 12
                
                background: Rectangle {
                    color: "#45475a"
                    radius: 4
                }

                onAccepted: backend.setCurrentPath(text)
            }
        }
    }

    // File List View
    ListView {
        id: fileList
        anchors {
            top: navBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 8
        }
        clip: true
        spacing: 4
        model: backend.fileList

        delegate: Rectangle {
            width: ListView.view.width
            height: 40
            color: mouseArea.containsMouse ? "#45475a" : "transparent"
            radius: 4

           RowLayout {
                anchors {
                    fill: parent
                    margins: 8
                }
                spacing: 12

                // File Icon
                Text {
                    text: modelData.icon || "📄"
                    font.pixelSize: 20
                    color: "#cdd6f4"
                }

                // File Name
                Text {
                    text: modelData.name || ""
                    font.pixelSize: 12
                    color: "#cdd6f4"
                    Layout.fillWidth: true
                }

                // File Size
                Text {
                    text: (modelData.isDir === true) ? "--" : formatFileSize(modelData.size || 0)
                    font.pixelSize: 12
                    color: "#a6adc8"
                    Layout.minimumWidth: 80
                }

                // Modified Date
                Text {
                    text: modelData.modified ? Qt.formatDateTime(modelData.modified, "yyyy-MM-dd hh:mm") : "--"
                    font.pixelSize: 12
                    color: "#a6adc8"
                    Layout.minimumWidth: 120
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onDoubleClicked: {
                    if (modelData && modelData.path && modelData.isDir === true) {
                        backend.setCurrentPath(modelData.path)
                    }
                }
            }
        }
    }

    // Helper Functions
    function formatFileSize(size) {
        const units = ['B', 'KB', 'MB', 'GB', 'TB']
        let index = 0
        while (size >= 1024 && index < units.length - 1) {
            size /= 1024
            index++
        }
        return `${size.toFixed(1)} ${units[index]}`
    }

    function toggleMaximize() {
        if (isMaximized) {
            x = restoreGeometry.x
            y = restoreGeometry.y
            width = restoreGeometry.width
            height = restoreGeometry.height
        } else {
            restoreGeometry = Qt.rect(x, y, width, height)
            x = 0
            y = 0
            width = parent.width
            height = parent.height
        }
        isMaximized = !isMaximized
    }
}