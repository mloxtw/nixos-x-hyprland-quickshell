import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ShellRoot {
    property var closeProcess: null
    
    PanelWindow {
        id: wallpaperWindow
        width: 800
        height: 600
        anchors {
            top: true
            left: true
            right: true
        }
        margins {
            top: 50
            left: (screen.width - width) / 2
            right: (screen.width - width) / 2
        }
        
        exclusiveZone: 0
        color: "#1e1e2e"
        
        Process {
            id: wallpaperLoader
            command: ["sh", "-c", "find ~/lwalpapers/wallpapers -type f \\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' \\) 2>/dev/null"]
            running: true
            
            stdout: SplitParser {
                onRead: function(data) {
                    var files = data.trim().split('\n');
                    for (var i = 0; i < files.length; i++) {
                        if (files[i] && files[i].length > 0) {
                            wallpaperModel.append({
                                "path": files[i],
                                "name": files[i].split('/').pop()
                            });
                        }
                    }
                }
            }
        }
        
        Process {
            id: swwwProcess
            running: false
        }
        
        Rectangle {
            id: mainRect
            anchors.fill: parent
            color: "#1e1e2e"
            border.color: "#89b4fa"
            border.width: 2
            radius: 10
            focus: true
            
            Component.onCompleted: {
                forceActiveFocus();
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: mainRect.forceActiveFocus()
            }
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15
                
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    
                    Text {
                        text: "Select Wallpaper"
                        font.pixelSize: 24
                        font.bold: true
                        color: "#cdd6f4"
                        Layout.fillWidth: true
                    }
                    
                    Button {
                        text: "✕"
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: 40
                        onClicked: Qt.quit()
                        
                        background: Rectangle {
                            color: parent.pressed ? "#f38ba8" : (parent.hovered ? "#eba0ac" : "#313244")
                            radius: 20
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            color: "#cdd6f4"
                            font.pixelSize: 20
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
                
                GridView {
                    id: wallpaperGrid
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    cellWidth: 250
                    cellHeight: 180
                    clip: true
                    
                    model: ListModel {
                        id: wallpaperModel
                    }
                    
                    delegate: Item {
                        width: 240
                        height: 170
                        
                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 5
                            color: "#313244"
                            radius: 8
                            border.color: mouseArea.containsMouse ? "#89b4fa" : "#45475a"
                            border.width: 2
                            
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 5
                                
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    color: "#181825"
                                    radius: 5
                                    
                                    Image {
                                        anchors.fill: parent
                                        anchors.margins: 2
                                        source: "file://" + model.path
                                        fillMode: Image.PreserveAspectCrop
                                        asynchronous: true
                                    }
                                }
                                
                                Text {
                                    Layout.fillWidth: true
                                    text: model.name
                                    color: "#cdd6f4"
                                    font.pixelSize: 11
                                    elide: Text.ElideMiddle
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                            
                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                
                                onClicked: {
                                    swwwProcess.command = ["swww", "img", model.path, "--transition-type", "fade"];
                                    swwwProcess.running = true;
                                    
                                    feedbackText.text = "Applied: " + model.path.split('/').pop();
                                    feedbackTimer.restart();
                                }
                            }
                        }
                    }
                }
                
                Button {
                    text: "Close"
                    Layout.alignment: Qt.AlignHCenter
                    onClicked: Qt.quit()
                    
                    background: Rectangle {
                        color: parent.pressed ? "#f38ba8" : (parent.hovered ? "#eba0ac" : "#f38ba8")
                        radius: 5
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: "#1e1e2e"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.bold: true
                    }
                }
            }
            
            Shortcut {
                sequence: "Esc"
                onActivated: Qt.quit()
            }
            
            Shortcut {
                sequence: "q"
                onActivated: Qt.quit()
            }
        }
        
        Text {
            id: feedbackText
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 60
            color: "#a6e3a1"
            font.pixelSize: 14
            opacity: 0
            
            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
        }
        
        Timer {
            id: feedbackTimer
            interval: 2000
            onTriggered: feedbackText.opacity = 0
            onRunningChanged: {
                if (running) feedbackText.opacity = 1
            }
        }
    }
}
