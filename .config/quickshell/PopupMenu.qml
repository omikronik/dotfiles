import Quickshell
import Quickshell.Wayland
import QtQuick

PopupWindow {
    id: popup
    
    property alias content: contentItem.data
    
    visible: false
    color: "transparent"
    
    anchor {
        window: null
        rect.x: 0
        rect.y: 0
        adjustment: PopupAdjustment.SlideX | PopupAdjustment.SlideY
    }
    
    mask: Region { item: background }
    
    function toggle(parentWindow, xPos, yPos) {
        if (visible) {
            visible = false
        } else {
            anchor.window = parentWindow
            anchor.rect.x = xPos
            anchor.rect.y = yPos
            visible = true
        }
    }
    
    Rectangle {
        id: background
        anchors.centerIn: parent
        width: contentItem.width
        height: contentItem.height
        color: Theme.sumiInk4
        radius: 12
        border.color: Theme.sumiInk6
        border.width: 1
        
        Item {
            id: contentItem
            anchors.fill: parent
        }
    }
}
