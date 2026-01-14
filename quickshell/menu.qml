import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

ShellRoot {
    PanelWindow {
        id: menuWindow
        width: 200
        height: 240
        anchors {
            top: true
            left: true
        }
        margins {
            top: 40
            left: 10
        }
        
        exclusiveZone: 0
        color: "transparent"
        
        Process {
            id: launcher
            running: false
        }
        
        Rectangle {
            anchors.fill: parent
            color: "#2e3440"
            border.color: "#88c0d0"
            border.width: 2
            radius: 10
            
            Column {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5
                
                // Wallpapers Option
                Rectangle {
                    width: parent.width
                    height: 55
                    color: mouseArea1.containsMouse ? "#3b4252" : "transparent"
                    radius: 5
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10
                        
                        Text {
                            text: "🎨"
                            font.pixelSize: 20
                            color: "#eceff4"
                        }
                        
                        Text {
                            text: "Wallpapers"
                            font.pixelSize: 14
                            color: "#eceff4"
                            Layout.fillWidth: true
                        }
                    }
                    
                    MouseArea {
                        id: mouseArea1
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            launcher.command = ["sh", "-c", "quickshell -p ~/.config/quickshell/wallpaper.qml & sleep 0.1 && pkill -f 'quickshell.*menu.qml'"];
                            launcher.running = true;
                        }
                    }
                }
                
                // Config Manager Option
                Rectangle {
                    width: parent.width
                    height: 55
                    color: mouseArea2.containsMouse ? "#3b4252" : "transparent"
                    radius: 5
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10
                        
                        Text {
                            text: "⚙"
                            font.pixelSize: 20
                            color: "#eceff4"
                        }
                        
                        Text {
                            text: "Config Manager"
                            font.pixelSize: 14
                            color: "#eceff4"
                            Layout.fillWidth: true
                        }
                    }
                    
                    MouseArea {
                        id: mouseArea2
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            launcher.command = ["sh", "-c", "quickshell -p ~/.config/quickshell/ConfigMenu.qml & sleep 0.1 && pkill -f 'quickshell.*menu.qml'"];
                            launcher.running = true;
                        }
                    }
                }
                
                // Rofi Option
                Rectangle {
                    width: parent.width
                    height: 55
                    color: mouseArea3.containsMouse ? "#3b4252" : "transparent"
                    radius: 5
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10
                        
                        Text {
                            text: "🔍"
                            font.pixelSize: 20
                            color: "#eceff4"
                        }
                        
                        Text {
                            text: "Rofi Launcher"
                            font.pixelSize: 14
                            color: "#eceff4"
                            Layout.fillWidth: true
                        }
                    }
                    
                    MouseArea {
                        id: mouseArea3
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            launcher.command = ["sh", "-c", "rofi -show drun & sleep 0.1 && pkill -f 'quickshell.*menu.qml'"];
                            launcher.running = true;
                        }
                    }
                }
                
                // Close Button
                Rectangle {
                    width: parent.width
                    height: 40
                    color: mouseArea4.containsMouse ? "#bf616a" : "#434c5e"
                    radius: 5
                    
                    Text {
                        anchors.centerIn: parent
                        text: "✕ Close"
                        font.pixelSize: 13
                        color: "#eceff4"
                    }
                    
                    MouseArea {
                        id: mouseArea4
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Qt.quit();
                        }
                    }
                }
            }
        }
    }
}
