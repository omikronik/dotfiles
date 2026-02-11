import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

PanelWindow {
    id: root

    property int cpuUsage: 0
    property var lastCpuTotal: 0
    property var lastCpuIdle: 0
    property int memUsage: 0

    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 30
    color: "transparent"
    HyprlandWindow.opacity: 1

    // CPU usage
    Process {
        id: cpuProc
        command: ["sh", "-c", "head -1 /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var p = data.trim().split(/\s+/)
                var idle = parseInt(p[4]) + parseInt(p[5])
                var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)
                if (lastCpuTotal > 0) {
                    root.cpuUsage = Math.round(100 * (1 - (idle - lastCpuIdle) / (total - lastCpuTotal)))
                }
                lastCpuTotal = total
                lastCpuIdle = idle
            }
        }
        Component.onCompleted: running = true
    }

    // Memory usage
    Process {
        id: memProc
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.trim().split(/\s+/)
                var total = parseInt(parts[1]) || 1
                var used = parseInt(parts[2]) || 0
                root.memUsage = Math.round(100 * used / total)
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true
            memProc.running = true
        }
    }


    PopupMenu {
        id: calendarPopup

        MiniCalendar {
            id: miniCalendar
            onVisibleChanged: {
                if (visible) {
                    currentDate = new Date()
                }
            }

        }
    }

    Item {
        anchors.fill: parent
        anchors.margins: 4

        /* template Text
         Text {
             id: CHANGEME
             color: Theme.fujiWhite
             font { pixelSize: Theme.fontSize; bold: false; family: Theme.fontFamily }
             leftPadding: 3
             rightPadding: 3

             text: CHANGEME
         }
         */

        // LEFT
        Rectangle {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            color: Theme.sumiInk4
            radius: 12

            implicitWidth: leftGroup.implicitWidth + 16
            implicitHeight: leftGroup.implicitHeight + 8

            RowLayout {
                id: leftGroup
                anchors.centerIn: parent
                spacing: 8

                ClickableItem {
                    id: clock

                    text: Qt.formatDateTime(new Date(), "dd/MM-HH:mm")

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: clock.text = Qt.formatDateTime(new Date(), "dd/MM-HH:mm")
                    }

                    onClicked: {
                        calendarPopup.toggle(
                            root,
                            clock.mapToItem(root, 0, 0).x,
                            root.height + 5
                        )
                    }
                }

                // Cpu
                ClickableItem {
                    text: " " + cpuUsage + "%"
                    clickable: false
                }

                // Mem
                ClickableItem {
                    text: " " + memUsage + "%"
                    clickable: false
                }

                ClickableItem {
                    id: kbItem

                    property string kbStatus: "off"
                    text: kbStatus === "on" ? "󰌌 on" : "󰌐 off"

                    Process {
                        id: kbStatusProc
                        command: ["/usr/bin/fish", "-c", "~/dotfiles/waybar-kb-status.fish"]
                        running: true

                        stdout: SplitParser {
                            onRead: data => {
                                if (data) kbItem.kbStatus = data.trim().toLowerCase()
                            }
                        }
                    }

                    Process {
                        id: toggleLaptopKbProc
                        command: ["/usr/bin/fish", "-c", "~/dotfiles/toggle-laptop-kb.fish"]
                        running: false

                        onExited: {
                            kbStatusProc.running = true
                        }
                    }

                    onClicked: {
                        toggleLaptopKbProc.running = true
                    }
                }
            }
        }


        // Center
        Rectangle {
            anchors.centerIn: parent

            color: Theme.sumiInk4
            radius: 12

            implicitWidth: centerGroup.implicitWidth + 16
            implicitHeight: centerGroup.implicitHeight + 8

            RowLayout {
                id: centerGroup
                anchors.centerIn: parent
                spacing: 8

                // Workspaces
                Repeater {
                    model: 9


                    ClickableItem {
                        property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                        property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

                        text: index + 1
                        textColor: isActive ? Theme.fujiWhite : (ws ? Theme.oldWhite : Theme.fujiGray)
                        bold: isActive

                        Component.onCompleted: {
                            console.log("Workspace", index + 1, "- Active:", isActive, "- Exists:", ws !== undefined)
                            console.log("Focused workspace ID:", Hyprland.focusedWorkspace?.id)
                        }
                        onClicked: Hyprland.dispatch("workspace " + (index + 1))
                    }
                }
            }
        }

        // RIGHT
        Rectangle {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            color: Theme.sumiInk4
            radius: 12

            implicitWidth: rightGroup.implicitWidth + 16
            implicitHeight: rightGroup.implicitHeight + 8

            RowLayout{
                id: rightGroup
                anchors.centerIn: parent
                spacing: 8

                ClickableItem {
                    text: "sample"
                    clickable: false
                }
            }
        }
    }
}
