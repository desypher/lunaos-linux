import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.3
import QtQuick.Window 2.15

Window {
    id: textEditor
    visible: true
    width: 800
    height: 600
    title: (backend.currentFile || "Untitled") + (backend.modified ? "*" : "") + " - Text Editor"

    property bool isMinimized: false
    signal closed()

    onClosing: function(close) {
        close.accepted = false
        closed()
    }

    function restore() {
        textEditor.show()
        textEditor.raise()
        textEditor.requestActivate()
        isMinimized = false
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

        ToolBar {
            Layout.fillWidth: true
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
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 30
            color: "#f0f0f0"  // Light gray background
            
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
