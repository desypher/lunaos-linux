import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Layouts 1.15
import LunaOS 1.0

Rectangle {
    id: terminal
    width: 640
    height: 400
    visible: true
    z: 1000 // Ensure terminal is on top
    color: "#181825" // Even darker background
    radius: 8
    border.color: "#f9e2af" // yellow border for accent
    border.width: 2

    property alias textInput: input
    property var commandHistory: []
    property int currentHistoryIndex: -1
    property string terminalOutput: ""
    property bool isMaximized: false
    property bool isMinimized: false
    property rect restoreGeometry: Qt.rect(x, y, width, height)

    property string windowTitle: "Terminal"  // Add this property
    
    MouseArea {
        id: windowMouseArea
        anchors.fill: parent
        z: -1
        onPressed: {
            terminal.parent.parent.bringToFront(windowTitle)
        }
    }

    signal closed()

    TerminalBackend {
        id: backend
        onOutputChanged: {
            // Add line break handling and wrap in pre tags for proper formatting
            terminalOutput += "<pre>> " + output.replace(/\n/g, "<br>") + "</pre>"
            // Scroll to bottom when new output is added
            outputArea.cursorPosition = outputArea.length
        }
    }

    function addToHistory(command) {
        commandHistory.push(command)
        currentHistoryIndex = commandHistory.length
    }

    function toggleMaximize() {
        if (isMaximized) {
            // Restore previous position and size
            x = restoreGeometry.x
            y = restoreGeometry.y
            width = restoreGeometry.width
            height = restoreGeometry.height
        } else {
            // Store current geometry before maximizing
            restoreGeometry = Qt.rect(x, y, width, height)
            // Get parent (desktop) dimensions
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

    Component.onCompleted: {
        console.log("Terminal started")
        terminalOutput =
            "<pre><font color='#f9e2af'>"
            + "     _..._      <br>"
            + "   .::::. `.    <br>"
            + "  :::::::.  :   <br>"
            + "  :::::::.  :   <br>"
            + "  `::::::.'     <br>"
            + "    `'\"'        <br>"
            + "    LunaOS      <br>"
            + "</font></pre>"
        backend.startShell()
    }

    // Remove the existing MouseArea and replace with these resize handles
     // Remove the existing resize MouseAreas and replace with these
    MouseArea {
        id: resizeLeft
        width: 5
        anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
        cursorShape: Qt.SizeHorCursor
        property int startX
        property int startWidth
        
        onPressed: {
            startX = mouseX
            startWidth = terminal.width
        }
        onPositionChanged: {
            if (pressed) {
                var dx = mouseX - startX
                var newWidth = Math.max(300, startWidth - dx)
                terminal.x += (terminal.width - newWidth)
                terminal.width = newWidth
            }
        }
    }

    MouseArea {
        id: resizeRight
        width: 5
        anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
        cursorShape: Qt.SizeHorCursor
        property int startX
        property int startWidth
        
        onPressed: {
            startX = mouseX
            startWidth = terminal.width
        }
        onPositionChanged: {
            if (pressed) {
                var dx = mouseX - startX
                terminal.width = Math.max(300, startWidth + dx)
            }
        }
    }

    MouseArea {
        id: resizeBottom
        height: 5
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
        cursorShape: Qt.SizeVerCursor
        property int startY
        property int startHeight
        
        onPressed: {
            startY = mouseY
            startHeight = terminal.height
        }
        onPositionChanged: {
            if (pressed) {
                var dy = mouseY - startY
                terminal.height = Math.max(200, startHeight + dy)
            }
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        // Replace existing title bar with standardized one
        Rectangle {
            id: titleBar
            width: parent.width
            height: 32
            color: "#181825"
            radius: 8

            Text {
                text: "Terminal"
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
                                if (modelData.action === "close") terminal.closed()
                                else if (modelData.action === "minimize") terminal.minimize()
                                else if (modelData.action === "maximize") terminal.toggleMaximize()
                            }
                        }
                    }
                }
            }

            MouseArea {
                id: controlMouseArea
                anchors.fill: parent
                hoverEnabled: true
                z: 1
                property point clickPos: "0,0"
                onPressed: {
                    clickPos = Qt.point(mouse.x, mouse.y)
                    terminal.parent.parent.bringToFront("Terminal")  // Add this line
                }
                onPositionChanged: {
                    if (pressed) {
                        var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                        terminal.x += delta.x
                        terminal.y += delta.y
                    }
                }
            }
        }

        ScrollView {
            width: parent.width
            height: parent.height - 120
            clip: true

            TextArea {
                id: outputArea
                textFormat: TextEdit.RichText
                text: terminalOutput
                readOnly: true
                wrapMode: TextArea.NoWrap
                color: "#f9e2af"
                selectByMouse: true                    // Enable mouse selection
                selectedTextColor: "#1e1e2e"           // Dark background for selected text
                selectionColor: "#f9e2af" 
                font.family: "monospace"
                font.pixelSize: 14
                leftPadding: 12
                rightPadding: 12
                topPadding: 12
                bottomPadding: 12
                
                background: Rectangle {
                    color: "#1e1e2e"
                    radius: 6
                    border.color: "#313244"
                    border.width: 1
                }
            }
        }

        RowLayout {
            width: parent.width
            height: 32
            spacing: 4

            Text {
                text: ">"
                color: "#f9e2af"
                font.family: "monospace"
                font.pixelSize: 14
                Layout.leftMargin: 8
                Layout.alignment: Qt.AlignVCenter
            }

            TextArea {
                id: input
                width: parent.width
                height: 32
                color: "#cdd6f4"
                selectionColor: "#f9e2af"
                font.family: "monospace"
                font.pixelSize: 14
                leftPadding: 12
                rightPadding: 12
                placeholderText: "Enter command..."
                placeholderTextColor: "#6c7086"
                
                background: Rectangle {
                    color: "#1e1e2e"
                    radius: 6
                    border.color: "#313244"
                    border.width: 1

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#313244"
                        anchors.bottom: parent.bottom
                    }
                }

                Keys.onReturnPressed: {
                    if (text.trim() !== "") {
                        backend.sendCommand(text)
                        addToHistory(text.trim())
                        text = ""
                    }
                }

                Keys.onUpPressed: {
                    if (currentHistoryIndex > 0) {
                        currentHistoryIndex--
                        text = commandHistory[currentHistoryIndex]
                    }
                }

                Keys.onDownPressed: {
                    if (currentHistoryIndex < commandHistory.length - 1) {
                        currentHistoryIndex++
                        text = commandHistory[currentHistoryIndex]
                    } else {
                        currentHistoryIndex = commandHistory.length
                        text = ""
                    }
                }
            }
        }
    }
}