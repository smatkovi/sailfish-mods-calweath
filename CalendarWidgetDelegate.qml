import QtQuick 2.4
import Sailfish.Silica 1.0
import org.nemomobile.calendar.lightweight 1.0
import Sailfish.Calendar 1.0

BackgroundItem {
    id: delegate
    property int pixelSize
    property real maxTimeLabelWidth
    property real labelLeftMargin
    property bool isToday
    property real timeWidth: timeLabel.implicitWidth
    property string eventLocation: ""  // wird von außen gesetzt
    
    property string dateLabel: {
        if (isToday) {
            return qsTrId("sailfish_calendar-la-today")
        } else {
            var weekday = Format.formatDate(startTime, Formatter.WeekdayNameStandalone)
            return weekday.charAt(0).toUpperCase() + weekday.substr(1)
        }
    }

    width: parent.width
    height: mainRow.height + 2*Theme.paddingMedium

    Row {
        id: mainRow
        x: labelLeftMargin
        width: parent.width - x
        spacing: Theme.paddingSmall
        anchors.verticalCenter: parent.verticalCenter

        Label {
            id: timeLabel
            width: Math.max(maxTimeLabelWidth, implicitWidth)
            color: highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
            font.pixelSize: delegate.pixelSize
            font.strikeout: cancelled
            text: allDay ? qsTrId("sailfish_calendar-la-all_day")
                         : Format.formatDate(startTime, Formatter.TimeValue)
        }

        CalendarColorBar {
            id: colorBar
            color: model.color
            height: nameCol.height
        }

        Column {
            id: nameCol
            width: parent.width - timeLabel.width - colorBar.width - 2*parent.spacing

            Label {
                id: nameLabel
                width: parent.width
                color: highlighted ? Theme.highlightColor : Theme.primaryColor
                text: CalendarTexts.ensureEventTitle(displayLabel)
                truncationMode: TruncationMode.Fade
                font.pixelSize: delegate.pixelSize
            }

            Label {
                id: locationLabel
                width: parent.width
                visible: eventLocation.length > 0
                text: eventLocation
                font.pixelSize: Theme.fontSizeTiny
                color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                truncationMode: TruncationMode.Fade
            }
        }
    }
}
