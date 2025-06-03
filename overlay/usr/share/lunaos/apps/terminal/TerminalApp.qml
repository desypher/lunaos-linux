import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
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

    signal closed()

    TerminalBackend {
        id: backend
        onOutputChanged: {
            // Add line break handling and wrap in pre tags for proper formatting
            terminalOutput += "> <pre>" + output.replace(/\n/g, "<br>") + "</pre>"
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

        // Enhanced title bar
        Rectangle {
            width: parent.width
            height: 32
            color: "#11111b"
            radius: 6
            
            Row {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8

                Text {
                    text: "Terminal"
                    color: "#f9e2af"
                    font.pixelSize: 14
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }

                // Add draggable area
                Rectangle {
                    width: parent.width - 150
                    height: parent.height - 16
                    color: "transparent"
                    
                    MouseArea {
                        anchors.fill: parent
                        drag.target: terminal
                        drag.axis: Drag.XAndY
                        drag.minimumX: 0
                        drag.minimumY: 0
                        drag.maximumX: parent.parent ? parent.parent.width - terminal.width : 0
                        drag.maximumY: parent.parent ? parent.parent.height - terminal.height : 0
                    }
                }

                // Window controls
                Row {
                    spacing: 6
                    
                    // Minimize button
                    Rectangle {
                        width: 18
                        height: 18
                        radius: 9
                        color: "#f9e2af"
                        
                        Text {
                            anchors.centerIn: parent
                            text: "−"
                            color: "#11111b"
                            font.pixelSize: 12
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: terminal.minimize()
                            onEntered: parent.opacity = 0.8
                            onExited: parent.opacity = 1
                        }
                    }
                    
                    // Maximize button
                    Rectangle {
                        width: 18
                        height: 18
                        radius: 9
                        color: "#a6e3a1"
                        
                        Text {
                            anchors.centerIn: parent
                            text: terminal.isMaximized ? "❐" : "□"
                            color: "#11111b"
                            font.pixelSize: 12
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: terminal.toggleMaximize()
                            onEntered: parent.opacity = 0.8
                            onExited: parent.opacity = 1
                        }
                    }

                    // Existing close button
                    Rectangle {
                        width: 18
                        height: 18
                        radius: 9
                        color: "#f38ba8"
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            anchors.centerIn: parent
                            text: "✖"
                            color: "#11111b"
                            font.pixelSize: 12
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: terminal.closed()
                            onEntered: parent.opacity = 0.8
                            onExited: parent.opacity = 1
                        }
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