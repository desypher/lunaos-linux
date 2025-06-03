import QtQuick 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.12
import LunaOS 1.0
import "qrc:/system" as SystemComponents
import LunaOS 1.0


Item {
    anchors.fill: parent
    visible: true

    SystemActions {
        id: backend
    }
    
    property bool showApplicationMenu: false
    property var currentTime: new Date()
    property var activeWindows: ({})  // Add this near the top with other properties
    property var runningApps: [] // Add this near other properties
    property int topZIndex: 1000
    property var windowZOrder: ({})  // Add this with other properties at the top

     property var systemApps: SystemApplications {
        id: systemAppsBackend
        onInstalledAppsChanged: updateApplicationList()
    }


    // Add the update function
    function updateApplicationList() {
        applicationMenuModel.clear()
        
        // Add built-in apps
        applicationMenuModel.append({"name": "File Manager", "category": "System", "icon": "📁", "builtin": true})
        applicationMenuModel.append({"name": "Terminal", "category": "System", "icon": "⌨️", "builtin": true})
        applicationMenuModel.append({"name": "Text Editor", "category": "Accessories", "icon": "📝", "builtin": true})
        applicationMenuModel.append({"name": "Calculator", "category": "Accessories", "icon": "🧮", "builtin": true})
        applicationMenuModel.append({"name": "Settings", "category": "System", "icon": "⚙️", "builtin": true})
        applicationMenuModel.append({"name": "Web Browser", "category": "Internet", "icon": "🌐", "builtin": true})
        applicationMenuModel.append({"name": "Media Player", "category": "Multimedia", "icon": "🎵", "builtin": true})
        applicationMenuModel.append({"name": "Image Viewer", "category": "Graphics", "icon": "🖼️", "builtin": true})
        
        // Add system installed apps
        var installedApps = systemAppsBackend.installedApps
        for (var i = 0; i < installedApps.length; i++) {
            applicationMenuModel.append({
                "name": installedApps[i],
                "category": "System Apps",
                "icon": "🚀",
                "builtin": false
            })
        }
    }

    function bringToFront(windowName) {
        topZIndex++
        windowZOrder[windowName] = topZIndex
        
        // Update z values for all windows
        if (terminalLoader.active) {
            terminalLoader.item.z = windowZOrder["Terminal"] || 0
        }
        if (fileManagerLoader.active) {
            fileManagerLoader.item.z = windowZOrder["File Manager"] || 0
        }
        if (textEditorLoader.active) {
            textEditorLoader.item.z = windowZOrder["Text Editor"] || 0
        }
    }

    Loader {
        id: terminalLoader
        active: false
        source: "qrc:/terminal/TerminalApp.qml"
        anchors.centerIn: parent
        visible: active
        z: 1000  // Ensure terminal appears above other desktop elements
        onLoaded: {
            // Update the arrays immediately when terminal is loaded
            if (!runningApps.includes("Terminal")) {
                var newApps = runningApps.slice()
                newApps.push("Terminal")
                runningApps = newApps
            }
            var newWindows = {}
            for (var key in activeWindows) {
                newWindows[key] = activeWindows[key]
            }
            newWindows["Terminal"] = true
            activeWindows = newWindows
            
            item.closed.connect(() => {
                terminalLoader.active = false
                var newWindows = {}
                for (var key in activeWindows) {
                    newWindows[key] = activeWindows[key]
                }
                newWindows["Terminal"] = false
                activeWindows = newWindows
                
                var newApps = runningApps.filter(function(app) {
                    return app !== "Terminal"
                })
                runningApps = newApps
            })
        }
        onStatusChanged: {
            if (status === Loader.Error) {
                console.log("Error loading terminal:", source)
            } else {
                console.log("Terminal loaded successfully")
            }
        }
    }

    Loader {
        id: fileManagerLoader
        active: false
        source: "qrc:/filemanager/FileManager.qml"
        anchors.centerIn: parent
        visible: active
        z: 1000

        onLoaded: {
            if (!runningApps.includes("File Manager")) {
                var newApps = runningApps.slice()
                newApps.push("File Manager")
                runningApps = newApps
            }
            var newWindows = {}
            for (var key in activeWindows) {
                newWindows[key] = activeWindows[key]
            }
            newWindows["File Manager"] = true
            activeWindows = newWindows
            
            item.closed.connect(() => {
                fileManagerLoader.active = false
                var newWindows = {}
                for (var key in activeWindows) {
                    newWindows[key] = activeWindows[key]
                }
                newWindows["File Manager"] = false
                activeWindows = newWindows
                
                var newApps = runningApps.filter(function(app) {
                    return app !== "File Manager"
                })
                runningApps = newApps
            })
        }
    }

    Loader {
        id: textEditorLoader
        active: false
        source: "qrc:/text/TextEditor.qml"
        anchors.centerIn: parent
        visible: active
        z: 1000

        onLoaded: {
            if (!runningApps.includes("Text Editor")) {
                var newApps = runningApps.slice()
                newApps.push("Text Editor")
                runningApps = newApps
            }
            var newWindows = {}
            for (var key in activeWindows) {
                newWindows[key] = activeWindows[key]
            }
            newWindows["Text Editor"] = true
            activeWindows = newWindows
            
            if (item && item.closed) {  // Check if item and closed signal exist
                item.closed.connect(function() {
                    textEditorLoader.active = false  // Fixed from fileManagerLoader
                    var newWindows = {}
                    for (var key in activeWindows) {
                        newWindows[key] = activeWindows[key]
                    }
                    newWindows["Text Editor"] = false
                    activeWindows = newWindows
                    
                    var newApps = runningApps.filter(function(app) {
                        return app !== "Text Editor"
                    })
                    runningApps = newApps
                })
            }
        }
    }

    Loader {
        id: systemWindowLoader
        active: false
        source: "qrc:/system/SystemWindow.qml"
        anchors.centerIn: parent
        visible: active
        z: 1000

        onLoaded: {
            if (!runningApps.includes(item.windowTitle)) {
                var newApps = runningApps.slice()
                newApps.push(item.windowTitle)
                runningApps = newApps
            }
            var newWindows = Object.assign({}, activeWindows)
            newWindows[item.windowTitle] = true
            activeWindows = newWindows
            
            item.closed.connect(() => {
                systemWindowLoader.active = false
                var newWindows = Object.assign({}, activeWindows)
                newWindows[item.windowTitle] = false
                activeWindows = newWindows
                
                var newApps = runningApps.filter(app => app !== item.windowTitle)
                runningApps = newApps
            })
        }
    }
    
    // Update time every second
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: currentTime = new Date()
    }
    
    // Desktop background
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#1e1e2e" }
            GradientStop { position: 0.3; color: "#181825" }
            GradientStop { position: 1.0; color: "#11111b" }
        }
        
        // Animated background stars
        Repeater {
            model: 50
            Rectangle {
                width: Math.random() * 3 + 1
                height: width
                radius: width / 2
                color: "#cdd6f4"
                opacity: Math.random() * 0.8 + 0.2
                x: Math.random() * parent.width
                y: Math.random() * parent.height
                
                SequentialAnimation on opacity {
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation { 
                        to: Math.random() * 0.3 + 0.1
                        duration: Math.random() * 3000 + 2000 
                    }
                    NumberAnimation { 
                        to: Math.random() * 0.8 + 0.4
                        duration: Math.random() * 3000 + 2000 
                    }
                }
            }
        }
    }
    
    // Desktop icons area
    GridView {
        id: desktopIcons
        anchors.fill: parent
        anchors.margins: 20
        anchors.bottomMargin: 80
        cellWidth: 100
        cellHeight: 100
        interactive: false
        
        model: ListModel {
            ListElement { name: "File Manager"; icon: "📁"; color: "#fab387" }
            ListElement { name: "Terminal"; icon: "⌨️"; color: "#a6e3a1" }
            ListElement { name: "Text Editor"; icon: "📝"; color: "#89b4fa" }
            ListElement { name: "Calculator"; icon: "🧮"; color: "#f9e2af" }
            ListElement { name: "Settings"; icon: "⚙️"; color: "#cba6f7" }
            ListElement { name: "Web Browser"; icon: "🌐"; color: "#74c7ec" }
        }
        
        delegate: Item {
            width: desktopIcons.cellWidth
            height: desktopIcons.cellHeight
            
            Rectangle {
                id: iconBackground
                width: 64
                height: 64
                radius: 12
                color: model.color
                opacity: 0.2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 10
                
                Text {
                    text: model.icon
                    font.pixelSize: 32
                    anchors.centerIn: parent
                }
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    
                    onEntered: {
                        iconBackground.opacity = 0.4
                        iconBackground.scale = 1.1
                    }
                    onExited: {
                        iconBackground.opacity = 0.2
                        iconBackground.scale = 1.0
                    }
                    onClicked: {
                        console.log("Opening " + model.name)
                        showApplicationMenu = false
                        if (model.name === "Terminal") {
                            if (!terminalLoader.active) {
                                console.log("Launching Terminal")
                                terminalLoader.active = true
                            } else if (!terminalLoader.item.visible) {
                                terminalLoader.item.visible = true
                                terminalLoader.item.isMinimized = false
                            }
                        } else if (model.name === "File Manager") {
                            if (!fileManagerLoader.active) {
                                console.log("Launching File Manager")
                                fileManagerLoader.active = true
                            } else if (!fileManagerLoader.item.visible) {
                                fileManagerLoader.item.visible = true
                                fileManagerLoader.item.isMinimized = false
                            }
                        } else if (model.name === "Text Editor") {
                            if (!textEditorLoader.active) {
                                console.log("Launching Text Editor")
                                textEditorLoader.active = true
                            } else if (!textEditorLoader.item.visible) {
                                textEditorLoader.item.visible = true
                                textEditorLoader.item.isMinimized = false
                            }
                        } else {
                            console.log("Opening " + model.name)
                        }
                    }
                    
                    Behavior on scale {
                        NumberAnimation { duration: 150 }
                    }
                }
                
                Behavior on opacity {
                    NumberAnimation { duration: 150 }
                }
                Behavior on scale {
                    NumberAnimation { duration: 150 }
                }
            }
            
            Text {
                text: model.name
                color: "#cdd6f4"
                font.pixelSize: 11
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                width: parent.width - 10
                wrapMode: Text.WordWrap
            }
        }
    }
    
    // Taskbar
    Rectangle {
        id: taskbar
        height: 60
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        color: "#313244"
        border.color: "#45475a"
        border.width: 1
        
        Row {
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            spacing: 12
            
            // Application menu button
            Button {
                width: 40
                height: 40
                
                background: Rectangle {
                    radius: 8
                    color: showApplicationMenu ? "#89b4fa" : (parent.hovered ? "#45475a" : "transparent")
                    
                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }
                
                contentItem: Text {
                    text: "🌙"
                    font.pixelSize: 20
                    color: "#cdd6f4"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: showApplicationMenu = !showApplicationMenu
            }
            
            // Running applications (dynamic)
            Repeater {
                model: runningApps
                
                Button {
                    width: 120
                    height: 40
                    
                    background: Rectangle {
                        radius: 8
                        color: activeWindows[modelData] ? "#45475a" : "#383a4a"
                        border.color: "#f9e2af" // Match terminal border color
                        border.width: 2
                        
                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }
                    
                    contentItem: Text {
                        text: modelData
                        font.pixelSize: 12
                        color: "#cdd6f4"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                    
                    onClicked: {
                        if (modelData === "Terminal") {
                            if (!terminalLoader.active) {
                                terminalLoader.active = true
                            } else {
                                if (terminalLoader.item.isMinimized) {
                                    terminalLoader.item.restore()
                                } else {
                                    terminalLoader.item.visible = !terminalLoader.item.visible
                                }
                            }
                            bringToFront("Terminal")
                        } else if (modelData === "File Manager") {
                            if (!fileManagerLoader.active) {
                                fileManagerLoader.active = true
                            } else {
                                if (fileManagerLoader.item.isMinimized) {
                                    fileManagerLoader.item.restore()
                                } else {
                                    fileManagerLoader.item.visible = !fileManagerLoader.item.visible
                                }
                            }
                            bringToFront("File Manager")
                        } else if (modelData === "Text Editor") {
                            if (!textEditorLoader.active) {
                                textEditorLoader.active = true
                            } else {
                                if (textEditorLoader.item.isMinimized) {
                                    textEditorLoader.item.restore()
                                } else {
                                    textEditorLoader.item.visible = !textEditorLoader.item.visible
                                }
                            }
                            bringToFront("Text Editor")
                        }
                    }
                }
            }
        }
        
        // System tray and clock
        Row {
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            spacing: 12

            // System indicators
            Row {
                spacing: 8
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    text: "📶"
                    color: "#a6e3a1"
                    font.pixelSize: 16
                }

                Text {
                    text: "🔋"
                    color: "#f9e2af"
                    font.pixelSize: 16
                }

                Text {
                    text: "🔊"
                    color: "#89b4fa"
                    font.pixelSize: 16
                }
            }

            // Clock
            Rectangle {
                width: 100
                height: 40
                radius: 8
                color: "#45475a"

                Column {
                    anchors.centerIn: parent

                    Text {
                        text: Qt.formatTime(currentTime, "hh:mm")
                        color: "#cdd6f4"
                        font.pixelSize: 14
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: Qt.formatDate(currentTime, "MMM dd")
                        color: "#a6adc8"
                        font.pixelSize: 10
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            // Power Menu Button
            Button {
                width: 40
                height: 40
                
                background: Rectangle {
                    radius: 8
                    color: powerMenu.visible ? "#89b4fa" : (parent.hovered ? "#45475a" : "transparent")
                    
                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                contentItem: Text {
                    text: "🖥️"
                    font.pixelSize: 18
                    color: "#f38ba8"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: powerMenu.visible = !powerMenu.visible
            }
        }

        SystemComponents.PowerMenu {
            id: powerMenu
            visible: false
            z: 1000
            anchors.right: parent.right
            anchors.bottom: parent.top
            anchors.bottomMargin: 8

            onPowerActionSelected: function(action) {
                powerMenu.visible = false
                switch(action) {
                    case "shutdown":
                        backend.shutdownSystem()
                        break
                    case "restart":
                        backend.restartSystem()
                        break
                    case "logout":
                        backend.logoutUser()
                        break
                    case "lock":
                        backend.lockSession()
                        break
                }
            }
        }
    }
    
    // Application menu
    Rectangle {
        id: applicationMenu
        width: 300
        height: 400
        anchors.left: parent.left
        anchors.bottom: taskbar.top
        anchors.leftMargin: 16
        anchors.bottomMargin: 8
        color: "#313244"
        radius: 12
        border.color: "#45475a"
        border.width: 1
        visible: showApplicationMenu
        opacity: showApplicationMenu ? 1 : 0
        
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
        
        
        Column {
            anchors.fill: parent
            anchors.margins: 16
            
            Text {
                text: "Applications"
                color: "#cdd6f4"
                font.pixelSize: 18
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Rectangle {
                width: parent.width
                height: 1
                color: "#45475a"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            ScrollView {
                width: parent.width
                height: parent.height - 40
                
                ListView {
                    model: ListModel {
                        id: applicationMenuModel
                    }
                    
                    Component.onCompleted: updateApplicationList()
                    
                    delegate: Rectangle {
                        width: parent.width
                        height: 48
                        color: mouseArea.containsMouse ? "#45475a" : "transparent"
                        radius: 8
                        
                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 12
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 12
                            
                            Text {
                                text: model.icon
                                font.pixelSize: 20
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            
                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    text: model.name
                                    color: "#cdd6f4"
                                    font.pixelSize: 14
                                }
                                
                                Text {
                                    text: model.category
                                    color: "#a6adc8"
                                    font.pixelSize: 10
                                }
                            }
                        }
                        
                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            
                            onClicked: {
                                console.log("Opening " + model.name)
                                showApplicationMenu = false
                                if (model.name === "Terminal") {
                                    if (!terminalLoader.active) {
                                        console.log("Launching Terminal")
                                        terminalLoader.active = true
                                    } else if (!terminalLoader.item.visible) {
                                        terminalLoader.item.visible = true
                                        terminalLoader.item.isMinimized = false
                                    }
                                } else if (model.name === "File Manager") {
                                    if (!fileManagerLoader.active) {
                                        console.log("Launching File Manager")
                                        fileManagerLoader.active = true
                                    } else if (!fileManagerLoader.item.visible) {
                                        fileManagerLoader.item.visible = true
                                        fileManagerLoader.item.isMinimized = false
                                    }
                                } else if (model.name === "Text Editor") {
                                    if (!textEditorLoader.active) {
                                        console.log("Launching Text Editor")
                                        textEditorLoader.active = true
                                    } else if (!textEditorLoader.item.visible) {
                                        textEditorLoader.item.visible = true
                                        textEditorLoader.item.isMinimized = false
                                    }
                                } else {
                                    systemWindowLoader.active = true
                                    systemWindowLoader.item.windowTitle = model.name
                                    systemWindowLoader.item.processName = model.name.toLowerCase()
                                    systemAppsBackend.launchApplication(model.name)
                                }
                            }
                        }
                        
                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }
                }
            }
        }
    }

    Button {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Install Software"
        
        onClicked: {
            var dialog = installDialog.createObject(applicationMenu)
            dialog.open()
        }
    }

    // Add dialog component
    Component {
        id: installDialog
        Dialog {
            title: "Install Software"
            standardButtons: Dialog.Ok | Dialog.Cancel
            
            TextField {
                id: packageName
                placeholderText: "Enter package name"
                width: parent.width
            }
            
            onAccepted: {
                if (packageName.text) {
                    systemAppsBackend.installApplication(packageName.text)
                }
            }
        }
    }
    
    // Click outside to close menu
    MouseArea {
        anchors.fill: parent
        enabled: showApplicationMenu
        onClicked: showApplicationMenu = false
        z: -1
    }
}
