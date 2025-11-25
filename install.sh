#!/bin/bash
set -e

echo "Installing Sailfish Weather & Calendar Mods..."

# Weather
devel-su cp DailyForecastItem.qml /usr/lib64/qt5/qml/Sailfish/Weather/
devel-su cp HourlyForecastItem.qml /usr/lib64/qt5/qml/Sailfish/Weather/
devel-su cp WeatherForecastModel.qml /usr/lib64/qt5/qml/Sailfish/Weather/

# Calendar Widget
devel-su cp CalendarWidget.qml /usr/lib64/qt5/qml/Sailfish/Calendar/
devel-su cp CalendarWidgetDelegate.qml /usr/lib64/qt5/qml/Sailfish/Calendar/

# Calendar Location Helper
mkdir -p ~/.local/share/calendar-loc-helper
cp calendar-loc-helper.qml ~/.local/share/calendar-loc-helper/main.qml

# Systemd Service
devel-su cp calendar-loc-helper.service /etc/systemd/system/
devel-su systemctl daemon-reload
devel-su systemctl enable calendar-loc-helper
devel-su systemctl start calendar-loc-helper

# Restart Lipstick
systemctl --user restart lipstick

echo "Done!"
