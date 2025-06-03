import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: systemWindow
    width: 800
    height: 600
    color: "#1e1e2e"
    radius: 8
    border.color: "#89b4fa"
    border.width: 1
    visible: true

    property string windowTitle: ""
    property bool isMaximized: false
    property bool isMinimized: false
    property rect restoreGeometry: Qt.rect(x, y, width, height)
    property string processName: ""

    signal closed()

    // Title Bar
    Rectangle {
        id: titleBar
        height: 32
        color: "#181825"
        radius: 8
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        Text {
            text: windowTitle
            color: "#cdd6f4"
            font.pixelSize: 12
            anchors.centerIn: parent
        }

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
                            if (modelData.action === "close") systemWindow.closed()
                            else if (modelData.action === "minimize") systemWindow.isMinimized = true
                            else if (modelData.action === "maximize") systemWindow.toggleMaximize()
                        }
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            property point clickPos: "0,0"
            onPressed: {
                clickPos = Qt.point(mouse.x, mouse.y)
                systemWindow.parent.parent.bringToFront(windowTitle)
            }
            onPositionChanged: {
                if (pressed) {
                    var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                    systemWindow.x += delta.x
                    systemWindow.y += delta.y
                }
            }
        }
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