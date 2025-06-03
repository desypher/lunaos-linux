import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.3

Rectangle {
    id: textEditor
    width: 800
    height: 600
    color: "#1e1e2e"
    radius: 8
    border.color: "#89b4fa"
    border.width: 1
    visible: true

    property bool isMaximized: false
    property bool isMinimized: false
    property rect restoreGeometry: Qt.rect(x, y, width, height)

    property string windowTitle: "Text Editor"  // Add this property
    
    MouseArea {
        id: windowMouseArea
        anchors.fill: parent
        z: -1
        onPressed: {
            terminal.parent.parent.bringToFront(windowTitle)
        }
    }

    signal closed()

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

    FileDialog {
        id: openDialog
        title: "Open File"
        folder: shortcuts.home
        selectExisting: true
        onAccepted: {
            backend.openFile(fileUrl.toString().replace("file://", ""))
        }
    }

    FileDialog {
        id: saveDialog
        title: "Save File"
        folder: shortcuts.home
        selectExisting: false
        onAccepted: {
            backend.saveFileAs(fileUrl.toString().replace("file://", ""))
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Title Bar
        Rectangle {
            id: titleBar
            height: 32
            color: "#181825"
            radius: 8
            Layout.fillWidth: true

            // Window Title
            Text {
                text: (backend.currentFile || "Untitled") + (backend.modified ? "*" : "") + " - Text Editor"
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
                z: 2

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
                        opacity: controlMouseArea.containsMouse ? 0.8 : 1.0

                        Behavior on opacity {
                            NumberAnimation { duration: 150 }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (modelData.action === "close") textEditor.closed()
                                else if (modelData.action === "minimize") textEditor.isMinimized = true
                                else if (modelData.action === "maximize") textEditor.toggleMaximize()
                            }
                        }
                    }
                }
            }

            // Drag Area
            MouseArea {
                id: controlMouseArea
                anchors.fill: parent
                hoverEnabled: true
                z: 1
                property point clickPos: "0,0"
                onPressed: {
                    clickPos = Qt.point(mouse.x, mouse.y)
                    textEditor.parent.parent.bringToFront("Text Editor")  // Add this line
                }
                onPositionChanged: {
                    if (pressed) {
                        var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                        textEditor.x += delta.x
                        textEditor.y += delta.y
                    }
                }
            }
        }

        ToolBar {
            Layout.fillWidth: true
            background: Rectangle {
                color: "#313244"
            }
            RowLayout {
                ToolButton {
                    text: "New"
                    onClicked: backend.newFile()
                }
                ToolButton {
                    text: "Open"
                    onClicked: openDialog.open()
                }
                ToolButton {
                    text: "Save"
                    onClicked: backend.saveFile()
                }
                ToolButton {
                    text: "Save As"
                    onClicked: saveDialog.open()
                }
            }
        }

         ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            TextArea {
                id: editor
                text: backend.content
                onTextChanged: backend.setContent(text)
                wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
                selectByMouse: true
                persistentSelection: true
                colr: "#e0e0e0"  // Light gray text
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 30
            color: "#313244"
            
            Label {
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                text: backend.currentFile || "Untitled"
                color: "#404040"  // Dark gray text
            }
        }
    }
}
