import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import LunaOS 1.0

ApplicationWindow {
    id: root
    visible: true
    visibility: "FullScreen"
    width: Screen.width
    height: Screen.height
    title: "LunaOS"
    color: "#1e1e2e"

    property var contextMenu: null

    screen: Qt.application.screens[0]

    Connections {
        target: Qt.application
        function onScreenAdded(screen) {
            root.width = screen.width
            root.height = screen.height
        }
    }

    Loader {
        id: pageLoader
        anchors.fill: parent
    }

    function switchToLogin() {
        pageLoader.source = "qrc:/qml/Login.qml"
    }

    function switchToDesktop() {
        pageLoader.source = "qrc:/qml/Desktop.qml"
    }

    Component.onCompleted: {
        switchToLogin()
    }
}