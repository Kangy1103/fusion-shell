import QtQuick

SequentialAnimation {
  id: puffSequence
  property Item targetItem: null

  // Puff out
  NumberAnimation {
    target: puffSequence.targetItem
    property: "puffScale"
    to: 1.1
    duration: 180
    easing.type: Easing.OutBack
  }

  // Bring back
  NumberAnimation {
    target: puffSequence.targetItem
    property: "puffScale"
    to: 1.0
    duration: 300
    easing.type: Easing.OutQuad
  }
}
