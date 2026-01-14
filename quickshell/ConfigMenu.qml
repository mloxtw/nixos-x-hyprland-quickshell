import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

ShellRoot {
    PanelWindow {
        id: configMenu
        color: "#2E3440"
        implicitWidth: 450
        implicitHeight: 650
        
        // Nord Colors
        readonly property color nord0: "#2E3440"
        readonly property color nord1: "#3B4252"
        readonly property color nord2: "#434C5E"
        readonly property color nord3: "#4C566A"
        readonly property color nord4: "#D8DEE9"
        readonly property color nord6: "#ECEFF4"
        readonly property color nord7: "#8FBCBB"
        readonly property color nord8: "#88C0D0"
        readonly property color nord9: "#81A1C1"
        readonly property color nord10: "#5E81AC"
        readonly property color nord11: "#BF616A"
        readonly property color nord13: "#EBCB8B"
        readonly property color nord14: "#A3BE8C"
        
        // Config file paths
        property var configFiles: [
            { name: "Fastfetch", icon: "", path: "~/.config/fastfetch/config.jsonc", color: nord8 },
            { name: "Waybar", icon: "", path: "~/.config/waybar/config.jsonc", color: nord10 },
            { name: "Rofi", icon: "", path: "~/.config/rofi/config.rasi", color: nord7 },
            { name: "QuickShell", icon: "", path: "~/.config/quickshell/", color: nord14 },
            { name: "Hyprland", icon: "", path: "~/.config/hypr/hyprland.conf", color: nord13 },
            { name: "Kitty", icon: "", path: "~/.config/kitty/kitty.conf", color: nord11 }
        ]
        
        Rectangle {
            id: mainRect
            anchors.fill: parent
            color: "#2E3440"
            radius: 16
            
            // Nord Colors
            readonly property color nord0: "#2E3440"
            readonly property color nord1: "#3B4252"
            readonly property color nord2: "#434C5E"
            readonly property color nord3: "#4C566A"
            readonly property color nord4: "#D8DEE9"
            readonly property color nord6: "#ECEFF4"
            readonly property color nord7: "#8FBCBB"
            readonly property color nord8: "#88C0D0"
            readonly property color nord9: "#81A1C1"
            readonly property color nord10: "#5E81AC"
            readonly property color nord11: "#BF616A"
            readonly property color nord13: "#EBCB8B"
            readonly property color nord14: "#A3BE8C"
            
            Item {
                anchors.fill: parent
                anchors.margins: 0
                
                Column {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 16
                    
                    // Header
                    Item {
                        width: parent.width
                        height: 70
                        
                        Rectangle {
                            anchors.fill: parent
                            color: mainRect.nord1
                            radius: 12
                            border.color: mainRect.nord3
                            border.width: 1
                            
                            Column {
                                anchors.centerIn: parent
                                spacing: 6
                                
                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: "⚙ CONFIG MANAGER"
                                    font.pixelSize: 24
                                    font.bold: true
                                    font.letterSpacing: 1
                                    color: mainRect.nord8
                                }
                                
                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: "Edit with Neovim"
                                    font.pixelSize: 12
                                    color: mainRect.nord4
                                    opacity: 0.6
                                }
                            }
                        }
                    }
                    
                    // Config Files List
                    Item {
                        width: parent.width
                        height: parent.height - 180
                        
                        Flickable {
                            anchors.fill: parent
                            contentHeight: configList.height
                            clip: true
                            boundsBehavior: Flickable.StopAtBounds
                            
                            Column {
                                id: configList
                                width: parent.width
                                spacing: 10
                                
                                Repeater {
                                    model: configMenu.configFiles
                                    
                                    Item {
                                        width: parent.width
                                        height: 60
                                        
                                        Rectangle {
                                            anchors.fill: parent
                                            color: configItemMouse.containsMouse ? mainRect.nord2 : mainRect.nord1
                                            radius: 10
                                            border.color: modelData.color
                                            border.width: configItemMouse.containsMouse ? 2 : 1
                                            
                                            Behavior on color { ColorAnimation { duration: 200 } }
                                            Behavior on border.width { NumberAnimation { duration: 200 } }
                                            
                                            MouseArea {
                                                id: configItemMouse
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                
                                                onClicked: {
                                                    configMenu.visible = false
                                                    var proc = Qt.createQmlObject('import Quickshell.Io; Process {}', configMenu)
                                                    proc.command = ["sh", "-c", "kitty -e nvim " + modelData.path]
                                                    proc.running = true
                                                }
                                            }
                                            
                                            Row {
                                                anchors.fill: parent
                                                anchors.leftMargin: 16
                                                anchors.rightMargin: 16
                                                spacing: 16
                                                
                                                // Icon circle
                                                Rectangle {
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    width: 44
                                                    height: 44
                                                    color: modelData.color
                                                    radius: 22
                                                    
                                                    Text {
                                                        anchors.centerIn: parent
                                                        text: modelData.icon
                                                        font.pixelSize: 22
                                                        color: configMenu.nord0
                                                    }
                                                }
                                                
                                                // Text info
                                                Column {
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    spacing: 4
                                                    width: parent.width - 100
                                                    
                                                    Text {
                                                        text: modelData.name
                                                        font.pixelSize: 15
                                                        font.bold: true
                                                        color: mainRect.nord6
                                                    }
                                                    
                                                    Text {
                                                        text: modelData.path
                                                        font.pixelSize: 10
                                                        font.family: "monospace"
                                                        color: mainRect.nord4
                                                        opacity: 0.6
                                                        elide: Text.ElideMiddle
                                                        width: parent.width
                                                    }
                                                }
                                                
                                                // Arrow
                                                Text {
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    text: "→"
                                                    font.pixelSize: 28
                                                    color: modelData.color
                                                    opacity: configItemMouse.containsMouse ? 1.0 : 0.4
                                                    
                                                    Behavior on opacity { NumberAnimation { duration: 200 } }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // Action buttons
                    Item {
                        width: parent.width
                        height: 90
                        
                        Column {
                            anchors.fill: parent
                            spacing: 8
                            
                            Row {
                                width: parent.width
                                height: 42
                                spacing: 8
                                
                                Rectangle {
                                    width: (parent.width - 8) / 2
                                    height: parent.height
                                    color: openAllMouse.containsMouse ? mainRect.nord10 : mainRect.nord9
                                    radius: 8
                                    
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                    
                                    MouseArea {
                                        id: openAllMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        
                                        onClicked: {
                                            configMenu.visible = false
                                            var pathsStr = ""
                                            for (var i = 0; i < configMenu.configFiles.length; i++) {
                                                pathsStr += configMenu.configFiles[i].path + " "
                                            }
                                            var proc = Qt.createQmlObject('import Quickshell.Io; Process {}', configMenu)
                                            proc.command = ["sh", "-c", "kitty -e nvim -p " + pathsStr]
                                            proc.running = true
                                        }
                                    }
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: " Open All Tabs"
                                        color: mainRect.nord6
                                        font.pixelSize: 13
                                        font.bold: true
                                    }
                                }
                                
                                Rectangle {
                                    width: (parent.width - 8) / 2
                                    height: parent.height
                                    color: browseMouse.containsMouse ? mainRect.nord8 : mainRect.nord7
                                    radius: 8
                                    
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                    
                                    MouseArea {
                                        id: browseMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        
                                        onClicked: {
                                            configMenu.visible = false
                                            var proc = Qt.createQmlObject('import Quickshell.Io; Process {}', configMenu)
                                            proc.command = ["sh", "-c", "kitty -e nvim ~/.config"]
                                            proc.running = true
                                        }
                                    }
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: " Browse Configs"
                                        color: mainRect.nord6
                                        font.pixelSize: 13
                                        font.bold: true
                                    }
                                }
                            }
                            
                            Rectangle {
                                width: parent.width
                                height: 38
                                color: closeMouse.containsMouse ? mainRect.nord11 : mainRect.nord2
                                radius: 8
                                
                                Behavior on color { ColorAnimation { duration: 200 } }
                                
                                MouseArea {
                                    id: closeMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    
                                    onClicked: Qt.quit()
                                }
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "✕ Close Menu"
                                    color: mainRect.nord4
                                    font.pixelSize: 12
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
