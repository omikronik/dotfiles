import QtQuick

Item {
    id: calendar
    
    width: 200
    height: 220
    
    property date currentDate: new Date()
    property int currentDay: currentDate.getDate()
    property int currentMonth: currentDate.getMonth()
    property int currentYear: currentDate.getFullYear()
    
    Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8
        
        // Month and year header
        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: Qt.formatDate(calendar.currentDate, "MMMM yyyy")
            color: Theme.fujiWhite
            font { pixelSize: Theme.fontSize; bold: true; family: Theme.fontFamily }
        }
        
        // Day names
        Grid {
            columns: 7
            spacing: 4
            width: parent.width
            
            Repeater {
                model: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
                Text {
                    width: 24
                    horizontalAlignment: Text.AlignHCenter
                    text: modelData
                    color: Theme.fujiGray
                    font { pixelSize: Theme.fontSize - 2; family: Theme.fontFamily }
                }
            }
        }
        
        // Calendar days
        Grid {
            columns: 7
            spacing: 4
            width: parent.width
            
            Repeater {
                model: {
                    var firstDay = new Date(calendar.currentYear, calendar.currentMonth, 1)
                    var firstDayOfWeek = (firstDay.getDay() + 6) % 7
                    var daysInMonth = new Date(calendar.currentYear, calendar.currentMonth + 1, 0).getDate()
                    
                    var days = []
                    for (var i = 0; i < firstDayOfWeek; i++) {
                        days.push(0)
                    }
                    for (var d = 1; d <= daysInMonth; d++) {
                        days.push(d)
                    }
                    return days
                }
                
                Rectangle {
                    width: 24
                    height: 24
                    radius: 4
                    color: {
                        if (modelData === 0) return "transparent"
                        if (modelData === calendar.currentDay) return Theme.waveBlue1
                        return "transparent"
                    }
                    
                    Text {
                        anchors.centerIn: parent
                        text: modelData === 0 ? "" : modelData
                        color: {
                            if (modelData === 0) return "transparent"
                            if (modelData === calendar.currentDay) return Theme.fujiWhite
                            return Theme.oldWhite
                        }
                        font { 
                            pixelSize: Theme.fontSize - 2
                            family: Theme.fontFamily
                            bold: modelData === calendar.currentDay
                        }
                    }
                }
            }
        }
    }
}
