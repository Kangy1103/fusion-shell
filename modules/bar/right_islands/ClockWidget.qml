import QtQuick

Item {
  id: clockDisplay
  implicitWidth: clockText.implicitWidth
  implicitHeight: clockText.implicitHeight
  required property var clock
  required property var theme

  Text {
    id: clockText
    text: Qt.formatDateTime(clockDisplay.clock.date, "hh:mm")
    color: clockDisplay.theme.text
    font.pointSize: 12
  }
}
