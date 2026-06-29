import QtQuick

Item {
  id: root
  required property Item target // Hovered app
  required property string text
  required property var theme
  property int delay: 400 // Time to show tooltip
  property int yOffset: 4

  width: 0
  height: 0

  property var _globalPos: target.mapToItem(null, 0, 0)

  Rectangle {
    id: tooltipBox
    visible: false
    x: root._globalPos.x + target.width / 2 - width / 2
    y: root._globalPos.y + target.height + root.yOffset
    width: Math.min(label.implicitWidth + 16, 260)
    height: label.implicitHeight + 10
    radius: 6
    color: root.theme.bg
    border.color: root.theme.border
    border.width: 1

    Text {
      id: label
      anchors.centerIn: parent
      text: root.text
      color: root.theme.text
      font.pointSize: 10
      elide: Text.ElideRight
    }
  }

  Timer {
    id: showTimer
    interval: root.delay
    onTriggered: {
      if (root.text !== "") {
        root._globalPos = root.target.mapToItem(null, 0, 0);
        tooltipBox.visible = true;
      }
    }
  }

  Connections {
    target: root.target
    function onContainsMouseChanged() {
      if (target.containsMouse)
        showTimer.start();
      else {
        showTimer.stop();
        tooltipBox.visible = false;
      }
    }
  }
}
