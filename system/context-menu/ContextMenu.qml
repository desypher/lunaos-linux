// ContextMenu.qml
import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    id: menuPopup
    modal: true
    focus: true

    property var actions: [] // List of { label: "Open", onTriggered: function() {...} }

    background: Rectangle {
        color: "#2e2e2e"
        border.color: "#555"
        radius: 4
    }

    contentItem: Column {
        spacing: 2
        padding: 8

        Repeater {
            model: actions
            delegate: Button {
                text: modelData.label
                width: 150
                onClicked: {
                    menuPopup.close()
                    modelData.onTriggered()
                }
                background: Rectangle {
                    color: hovered ? "#444" : "transparent"
                    radius: 2
                }
                contentItem: Text {
                    text: modelData.label
                    color: "white"
                }
            }
        }
    }
}