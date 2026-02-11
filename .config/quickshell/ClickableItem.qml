import QtQuick

Rectangle {
    id: root
    
    property alias text: itemText.text
    property color textColor: Theme.fujiWhite
    property bool bold: false
    property bool clickable: true
    
    signal clicked()
    
    color: clickable && mouseArea.containsMouse ? Theme.waveBlue1 : "transparent"
    radius: 6
    
    implicitWidth: itemText.implicitWidth + 8
    implicitHeight: itemText.implicitHeight + 2
    
    Behavior on color {
        ColorAnimation { duration: 100 }
    }
    
    Text {
        id: itemText
        anchors.centerIn: parent
        color: root.textColor
        font { pixelSize: Theme.fontSize; bold: root.bold; family: Theme.fontFamily }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: clickable
        cursorShape: clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: if (clickable) root.clicked()
    }
}
