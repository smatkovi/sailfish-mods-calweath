import QtQuick 2.0
import QtQuick.Window 2.0
import org.nemomobile.calendar 1.0
import Nemo.DBus 2.0

Window {
    id: root
    visible: false
    width: 1
    height: 1

    AgendaModel {
        id: agenda
        startDate: new Date()
        endDate: {
            var d = new Date()
            d.setDate(d.getDate() + 14)
            return d
        }
    }

    DBusAdaptor {
        service: "com.example.CalendarLoc"
        path: "/com/example/CalendarLoc"
        iface: "com.example.CalendarLoc"

        function getUpcoming(days, limit) {
            var now = new Date()
            var end = new Date()
            end.setDate(now.getDate() + days)
            agenda.startDate = now
            agenda.endDate = end

            var results = []
            var count = Math.min(agenda.count, limit)
            
            for (var i = 0; i < count; i++) {
                var ev = agenda.get(i, 256)
                if (ev && ev.startTime) {
                    var title = ev.displayLabel || ""
                    var key
                    if (title.indexOf("HTM") >= 0) {
                        key = title.substring(0, 30)
                    } else {
                        var hour = ev.startTime.getHours()
                        var day = ev.startTime.getDate()
                        var month = ev.startTime.getMonth()
                        key = title.substring(0, 20) + "_" + month + "_" + day + "_" + hour
                    }
                    results.push({
                        title: title,
                        location: ev.location || "",
                        key: key
                    })
                }
            }
            return JSON.stringify(results)
        }
    }

    Component.onCompleted: console.log("Calendar Location Helper running, events: " + agenda.count)
}
