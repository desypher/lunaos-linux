import QtQuick 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.12
import QtMultimedia 5.15
import LunaOS 1.0

Item {
    anchors.fill: parent
    visible: true
    
    property bool isLoggingIn: false
    
    // Linux Authentication Backend
    LinuxAuthenticator {
        id: authenticator
        onAuthenticationResult: function(success, message) {
            isLoggingIn = false
            if (success) {
                loginSuccess()
            } else {
                showError(message)
            }
        }
    }
    
    // Background with subtle gradient
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#1e1e2e" }
            GradientStop { position: 1.0; color: "#181825" }
        }
        
        // Subtle animated background pattern
        Repeater {
            model: 20
            Rectangle {
                width: 2
                height: 2
                radius: 1
                color: "#45475a"
                opacity: 0.3
                x: Math.random() * parent.width
                y: Math.random() * parent.height
                
                SequentialAnimation on opacity {
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.1; duration: 2000 + Math.random() * 2000 }
                    NumberAnimation { to: 0.5; duration: 2000 + Math.random() * 2000 }
                }
            }
        }
    }
    
    // Main login container
    Rectangle {
        id: loginContainer
        width: 320
        height: 440
        anchors.centerIn: parent
        color: "#313244"
        radius: 12
        border.color: "#45475a"
        border.width: 1
        
        // Subtle shadow effect
        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 8
            radius: 16
            samples: 33
            color: "#11111b"
            opacity: 0.5
        }
        
        Column {
            anchors.centerIn: parent
            spacing: 24
            
            // Logo section
            Item {
                width: 96
                height: 96
                anchors.horizontalCenter: parent.horizontalCenter
                
                Rectangle {
                    anchors.fill: parent
                    radius: 48
                    color: "#89b4fa"
                    opacity: 0.1
                }
                
                // Placeholder for logo - replace with actual image
                Text {
                    anchors.centerIn: parent
                    text: "🌙"
                    font.pixelSize: 48
                    color: "#89b4fa"
                }
                
                // Pulsing animation
                SequentialAnimation on scale {
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation { to: 1.05; duration: 2000; easing.type: Easing.InOutQuad }
                    NumberAnimation { to: 1.0; duration: 2000; easing.type: Easing.InOutQuad }
                }
            }
            
            Text {
                text: "Welcome to LunaOS"
                color: "#cdd6f4"
                font.pixelSize: 24
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Text {
                text: "Sign in to continue"
                color: "#a6adc8"
                font.pixelSize: 14
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            // Input fields
            Column {
                spacing: 12
                anchors.horizontalCenter: parent.horizontalCenter
                
                TextField {
                    id: username
                    placeholderText: "Username"
                    width: 260
                    height: 44
                    font.pixelSize: 16
                    color: "#cdd6f4"
                    placeholderTextColor: "#6c7086"
                    leftPadding: 16
                    rightPadding: 16
                    
                    background: Rectangle {
                        radius: 8
                        color: username.focus ? "#45475a" : "#383a4a"
                        border.color: username.focus ? "#89b4fa" : "transparent"
                        border.width: 2
                        
                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                        Behavior on border.color {
                            ColorAnimation { duration: 200 }
                        }
                    }
                }
                
                TextField {
                    id: password
                    placeholderText: "Password"
                    echoMode: TextInput.Password
                    width: 260
                    height: 44
                    font.pixelSize: 16
                    color: "#cdd6f4"
                    placeholderTextColor: "#6c7086"
                    leftPadding: 16
                    rightPadding: 16
                    
                    background: Rectangle {
                        radius: 8
                        color: password.focus ? "#45475a" : "#383a4a"
                        border.color: password.focus ? "#89b4fa" : "transparent"
                        border.width: 2
                        
                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                        Behavior on border.color {
                            ColorAnimation { duration: 200 }
                        }
                    }
                    
                    Keys.onReturnPressed: loginButton.clicked()
                }
            }
            
            // Error message
            Text {
                id: errorMessage
                text: ""
                color: "#f38ba8"
                font.pixelSize: 12
                anchors.horizontalCenter: parent.horizontalCenter
                opacity: 0
                
                Behavior on opacity {
                    NumberAnimation { duration: 300 }
                }
            }
            
            // Login button
            Button {
                id: loginButton
                text: isLoggingIn ? "Signing in..." : "Sign In"
                width: 260
                height: 44
                enabled: !isLoggingIn && username.text.length > 0 && password.text.length > 0
                anchors.horizontalCenter: parent.horizontalCenter
                
                background: Rectangle {
                    color: loginButton.enabled ? (loginButton.pressed ? "#7c3aed" : "#89b4fa") : "#6c7086"
                    radius: 8
                    
                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }
                
                contentItem: Text {
                    text: loginButton.text
                    font.pixelSize: 16
                    font.bold: true
                    color: loginButton.enabled ? "#11111b" : "#45475a"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: {
                    attemptLogin()
                }
                
                // Loading animation
                Rectangle {
                    width: 20
                    height: 20
                    radius: 10
                    color: "transparent"
                    border.color: "#11111b"
                    border.width: 2
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    visible: isLoggingIn
                    
                    RotationAnimation on rotation {
                        running: isLoggingIn
                        loops: Animation.Infinite
                        from: 0
                        to: 360
                        duration: 1000
                    }
                }
            }
        }
    }
    
    // Footer
    Text {
        text: "© 2025 LunaOS - Embrace the Night"
        color: "#6c7086"
        font.pixelSize: 12
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 24
    }

    SoundEffect {
        id: bootSound
        source: "qrc:/audio/boot.wav"
    }

    Component.onCompleted: {
        bootSound.play()
    }
    
    // Functions
    function attemptLogin() {
        isLoggingIn = true
        errorMessage.opacity = 0
        
        // Use real Linux authentication instead of fake timer
        authenticator.authenticateUser(username.text, password.text)
    }
    
    function showError(message) {
        errorMessage.text = message
        errorMessage.opacity = 1
        isLoggingIn = false
    }
    
    function loginSuccess() {
        console.log("Login successful! Transitioning to desktop...")
        LunaOS.Controller.loginSuccess()
    }
}