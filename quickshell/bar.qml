import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Io

ShellRoot {
    PanelWindow {
        id: bar
        
        anchors {
            top: true
            left: true
            right: true
        }
        
        property bool launcherOpen: false
        
        height: 32
        color: "#2E3440"
        
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            spacing: 16
            
            // NixOS Logo Launcher
            Rectangle {
                width: 28
                height: 28
                radius: 6
                color: launcherMouseArea.containsMouse ? "#434C5E" : "#3B4252"
                border.color: bar.launcherOpen ? "#5E81AC" : "transparent"
                border.width: 2
                
                Behavior on color { ColorAnimation { duration: 150 } }
                Behavior on border.color { ColorAnimation { duration: 150 } }
                
                Text {
                    anchors.centerIn: parent
                    text: "❄"
                    color: "#5E81AC"
                    font.pixelSize: 20
                    font.bold: true
                }
                
                MouseArea {
                    id: launcherMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    
                    onClicked: {
                        bar.launcherOpen = !bar.launcherOpen
                        if (bar.launcherOpen) {
                            searchInput.forceActiveFocus()
                        }
                    }
                }
            }
            
            Rectangle {
                width: 1
                height: 20
                color: "#4C566A"
            }
            
            // Workspaces
            RowLayout {
                spacing: 8
                
                Repeater {
                    model: 10
                    
                    Rectangle {
                        width: 32
                        height: 24
                        radius: 4
                        
                        property bool isActive: Hyprland.focusedWorkspace ? 
                            Hyprland.focusedWorkspace.id === (index + 1) : false
                        property bool hasWindows: {
                            for (var i = 0; i < Hyprland.workspaces.values.length; i++) {
                                if (Hyprland.workspaces.values[i].id === (index + 1)) {
                                    return true
                                }
                            }
                            return false
                        }
                        
                        color: isActive ? "#5E81AC" : (hasWindows ? "#3B4252" : "#2E3440")
                        border.color: isActive ? "#81A1C1" : (hasWindows ? "#4C566A" : "transparent")
                        border.width: 1
                        
                        Behavior on color { ColorAnimation { duration: 150 } }
                        Behavior on border.color { ColorAnimation { duration: 150 } }
                        
                        Text {
                            anchors.centerIn: parent
                            text: index + 1
                            color: isActive ? "#ECEFF4" : (hasWindows ? "#D8DEE9" : "#4C566A")
                            font.family: "monospace"
                            font.pixelSize: 12
                            font.bold: isActive
                            
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                                Hyprland.dispatch("workspace " + (index + 1))
                            }
                        }
                    }
                }
            }
            
            Item { Layout.fillWidth: true }
            
            // Center - Active Window Title
            Text {
                id: windowTitle
                text: Hyprland.focusedWindow ? Hyprland.focusedWindow.title : "Hyprland"
                color: "#D8DEE9"
                font.family: "monospace"
                font.pixelSize: 12
                elide: Text.ElideRight
                Layout.maximumWidth: 400
            }
            
            Item { Layout.fillWidth: true }
            
            // System Stats
            RowLayout {
                spacing: 20
                
                RowLayout {
                    spacing: 6
                    Text {
                        text: "󰻠"
                        color: "#88C0D0"
                        font.family: "monospace"
                        font.pixelSize: 14
                    }
                    Text {
                        id: cpuText
                        text: "0%"
                        color: "#88C0D0"
                        font.family: "monospace"
                        font.pixelSize: 12
                        Timer {
                            interval: 2000
                            running: true
                            repeat: true
                            onTriggered: {
                                cpuText.text = Math.floor(Math.random() * 60 + 20) + "%"
                            }
                        }
                    }
                }
                
                RowLayout {
                    spacing: 6
                    Text {
                        text: "󰋊"
                        color: "#81A1C1"
                        font.family: "monospace"
                        font.pixelSize: 14
                    }
                    Text {
                        id: memText
                        text: "0%"
                        color: "#81A1C1"
                        font.family: "monospace"
                        font.pixelSize: 12
                        Timer {
                            interval: 2000
                            running: true
                            repeat: true
                            onTriggered: {
                                memText.text = Math.floor(Math.random() * 40 + 40) + "%"
                            }
                        }
                    }
                }
                
                RowLayout {
                    spacing: 6
                    Text {
                        text: "󰓅"
                        color: "#A3BE8C"
                        font.family: "monospace"
                        font.pixelSize: 14
                    }
                    Text {
                        text: "1.2 MB/s"
                        color: "#A3BE8C"
                        font.family: "monospace"
                        font.pixelSize: 12
                    }
                }
            }
            
            Item { Layout.fillWidth: true }
            
            // Status Icons & Time
            RowLayout {
                spacing: 16
                
                Text {
                    text: "󰖨"
                    color: "#88C0D0"
                    font.family: "monospace"
                    font.pixelSize: 14
                }
                
                RowLayout {
                    spacing: 4
                    Text {
                        text: "󰕾"
                        color: "#EBCB8B"
                        font.family: "monospace"
                        font.pixelSize: 14
                    }
                    Text {
                        text: "70%"
                        color: "#EBCB8B"
                        font.family: "monospace"
                        font.pixelSize: 11
                    }
                }
                
                RowLayout {
                    spacing: 4
                    Text {
                        id: batteryIcon
                        text: "󰁹"
                        color: "#A3BE8C"
                        font.family: "monospace"
                        font.pixelSize: 14
                    }
                    Text {
                        id: batteryText
                        text: "100%"
                        color: "#A3BE8C"
                        font.family: "monospace"
                        font.pixelSize: 11
                        property real batteryLevel: 100
                        Timer {
                            interval: 5000
                            running: true
                            repeat: true
                            onTriggered: {
                                batteryText.batteryLevel = Math.max(20, batteryText.batteryLevel - 0.5)
                                batteryText.text = Math.floor(batteryText.batteryLevel) + "%"
                                if (batteryText.batteryLevel > 50) {
                                    batteryText.color = "#A3BE8C"
                                    batteryIcon.color = "#A3BE8C"
                                } else if (batteryText.batteryLevel > 20) {
                                    batteryText.color = "#EBCB8B"
                                    batteryIcon.color = "#EBCB8B"
                                } else {
                                    batteryText.color = "#BF616A"
                                    batteryIcon.color = "#BF616A"
                                }
                            }
                        }
                    }
                }
                
                Rectangle {
                    width: 1
                    height: 16
                    color: "#4C566A"
                }
                
                RowLayout {
                    spacing: 6
                    Text {
                        text: "󰃭"
                        color: "#D8DEE9"
                        font.family: "monospace"
                        font.pixelSize: 14
                    }
                    Text {
                        id: dateText
                        color: "#D8DEE9"
                        font.family: "monospace"
                        font.pixelSize: 12
                    }
                }
                
                RowLayout {
                    spacing: 6
                    Text {
                        text: "󰥔"
                        color: "#ECEFF4"
                        font.family: "monospace"
                        font.pixelSize: 14
                    }
                    Text {
                        id: timeText
                        color: "#ECEFF4"
                        font.family: "monospace"
                        font.pixelSize: 12
                        font.bold: true
                    }
                }
            }
        }
        
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                var now = new Date()
                timeText.text = Qt.formatTime(now, "HH:mm")
                dateText.text = Qt.formatDate(now, "ddd MMM dd")
            }
            Component.onCompleted: triggered()
        }
    }
    
    // Overlay launcher window
    LayerWindow {
        id: launcherWindow
        
        anchors {
            top: true
            left: true
        }
        
        margins {
            top: 40
            left: 12
        }
        
        width: 340
        height: bar.launcherOpen ? 470 : 0
        
        visible: bar.launcherOpen
        
        Behavior on height {
            NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
        }
        
        Rectangle {
            anchors.fill: parent
            color: "#3B4252"
            radius: 8
            border.color: "#5E81AC"
            border.width: 2
            clip: true
            
            opacity: bar.launcherOpen ? 1 : 0
            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
            
            Column {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8
                
                Rectangle {
                    width: parent.width
                    height: 40
                    color: "#2E3440"
                    radius: 6
                    border.color: searchInput.activeFocus ? "#5E81AC" : "#4C566A"
                    border.width: 1
                    Behavior on border.color { ColorAnimation { duration: 150 } }
                    
                    Row {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10
                        
                        Text {
                            text: ""
                            color: "#88C0D0"
                            font.family: "monospace"
                            font.pixelSize: 16
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        TextInput {
                            id: searchInput
                            width: parent.width - 36
                            color: "#ECEFF4"
                            font.family: "monospace"
                            font.pixelSize: 13
                            anchors.verticalCenter: parent.verticalCenter
                            
                            onTextChanged: {
                                appList.model.clear()
                                var apps = [
                                    { name: "Firefox", icon: "󰈹", cmd: "firefox" },
                                    { name: "Chromium", icon: "", cmd: "chromium" },
                                    { name: "Kitty", icon: "", cmd: "kitty" },
                                    { name: "Alacritty", icon: "", cmd: "alacritty" },
                                    { name: "Thunar", icon: "󰉋", cmd: "thunar" },
                                    { name: "Nautilus", icon: "󰉋", cmd: "nautilus" },
                                    { name: "VS Code", icon: "󰨞", cmd: "code" },
                                    { name: "Discord", icon: "󰙯", cmd: "discord" },
                                    { name: "Spotify", icon: "󰓇", cmd: "spotify" },
                                    { name: "Steam", icon: "󰓓", cmd: "steam" },
                                    { name: "Htop", icon: "󰍛", cmd: "kitty htop" },
                                    { name: "Btop", icon: "󰍛", cmd: "kitty btop" },
                                    { name: "Settings", icon: "", cmd: "gnome-control-center" },
                                    { name: "Pavucontrol", icon: "󰕾", cmd: "pavucontrol" }
                                ]
                                var filter = searchInput.text.toLowerCase()
                                for (var i = 0; i < apps.length; i++) {
                                    if (!filter || apps[i].name.toLowerCase().includes(filter)) {
                                        appList.model.append(apps[i])
                                    }
                                }
                            }
                            
                            Text {
                                text: "Search applications..."
                                color: "#4C566A"
                                font.family: "monospace"
                                font.pixelSize: 13
                                visible: !searchInput.text
                            }
                        }
                    }
                }
                
                Rectangle {
                    width: parent.width
                    height: 1
                    color: "#4C566A"
                }
                
                ListView {
                    id: appList
                    width: parent.width
                    height: parent.height - 57
                    spacing: 3
                    clip: true
                    
                    model: ListModel {
                        Component.onCompleted: {
                            append({ name: "Firefox", icon: "󰈹", cmd: "firefox" })
                            append({ name: "Chromium", icon: "", cmd: "chromium" })
                            append({ name: "Kitty", icon: "", cmd: "kitty" })
                            append({ name: "Alacritty", icon: "", cmd: "alacritty" })
                            append({ name: "Thunar", icon: "󰉋", cmd: "thunar" })
                            append({ name: "Nautilus", icon: "󰉋", cmd: "nautilus" })
                            append({ name: "VS Code", icon: "󰨞", cmd: "code" })
                            append({ name: "Discord", icon: "󰙯", cmd: "discord" })
                            append({ name: "Spotify", icon: "󰓇", cmd: "spotify" })
                            append({ name: "Steam", icon: "󰓓", cmd: "steam" })
                            append({ name: "Htop", icon: "󰍛", cmd: "kitty htop" })
                            append({ name: "Btop", icon: "󰍛", cmd: "kitty btop" })
                            append({ name: "Settings", icon: "", cmd: "gnome-control-center" })
                            append({ name: "Pavucontrol", icon: "󰕾", cmd: "pavucontrol" })
                        }
                    }
                    
                    delegate: Rectangle {
                        width: appList.width
                        height: 44
                        color: mouseArea.containsMouse ? "#434C5E" : "transparent"
                        radius: 6
                        Behavior on color { ColorAnimation { duration: 100 } }
                        
                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            anchors.rightMargin: 14
                            spacing: 14
                            
                            Text {
                                text: model.icon
                                color: "#88C0D0"
                                font.family: "monospace"
                                font.pixelSize: 22
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            
                            Text {
                                text: model.name
                                color: "#ECEFF4"
                                font.family: "monospace"
                                font.pixelSize: 14
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        
                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                                Hyprland.dispatch("exec " + model.cmd)
                                bar.launcherOpen = false
                                searchInput.text = ""
                            }
                        }
                    }
                }
            }
        }
    }
}
