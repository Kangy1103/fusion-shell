import QtQuick

Item {
  id: appsButton
  implicitWidth: 32
  implicitHeight: 32
  required property var theme
  signal clicked

  Image {
    anchors.centerIn: parent
    source: Qt.resolvedUrl("../../../icons/capsule-box.png")
    sourceSize.width: 28
    sourceSize.height: 28
    fillMode: Image.PreserveAspectFit

    MouseArea {
      anchors.fill: parent
      onClicked: appsButton.clicked()
    }
  }
}
