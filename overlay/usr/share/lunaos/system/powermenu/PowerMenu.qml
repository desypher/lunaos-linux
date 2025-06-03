import QtQuick 2.12
import QtQuick.Controls 2.5

Rectangle {
    id: powerMenu
    width: 200
    height: 180
    color: "#313244"
    radius: 12
    border.color: "#45475a"
    visible: false
    z: 9999

    signal powerActionSelected(string action)

    Column {
        spacing: 12

        Repeater {
            model: [
                { icon: "🔒", label: "Lock", action: "lock" },
                { icon: "🔁", label: "Restart", action: "restart" },
                { icon: "🚪", label: "Log Out", action: "logout" },
                { icon: "🖥️", label: "Shut Down", action: "shutdown" }
            ]

            delegate: Rectangle {
                width: parent.width - 24
                height: 50
                color: mouseArea.containsMouse ? "#45475a" : "transparent"
                radius: 6

                Row {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 10
                    
                    // Icon
                    Rectangle {
                        width: 24
                        height: 24
                        color: "transparent"
                        Text {
                            text: modelData.icon
                            font.pixelSize: 18
                            color: "#cdd6f4"
                        }
                    }

                    // Label
                    Text {
                        text: modelData.label
                        font.pixelSize: 14
                        color: "#cdd6f4"
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        powerMenu.visible = false
                        powerMenu.powerActionSelected(modelData.action)
                    }
                }
            }
        }
    }
}