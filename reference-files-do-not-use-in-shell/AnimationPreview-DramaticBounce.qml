// Created by Kangy w/ OpenCode AI Assistance
// Version: 0.1.0-20260624

import QtQuick
import QtQuick.Window

Window {
  width: 1100; height: 700; visible: true
  title: "Dramatic Bounce — Enter/Space open · Esc close"
  color: "#120f1b"

  Item { anchors.fill: parent; focus: true
    Keys.onReturnPressed: openIt(); Keys.onSpacePressed: openIt(); Keys.onEscapePressed: closeIt()
  }

  Text {
    anchors { top: parent.top; left: parent.left; margins: 16 }
    text: "Dramatic Bounce"; color: "#97b6ca"
    font { family: "JetBrainsMono Nerd Font"; pixelSize: 20; bold: true }
    visible: !box.visible
  }
  Text {
    anchors { bottom: parent.bottom; left: parent.left; margins: 16 }
    text: "Enter/Space open    Esc close"
    color: "#555"; font { family: "JetBrainsMono Nerd Font"; pixelSize: 13 }
  }

  Item { id: box; anchors.centerIn: parent; width: 600; height: 400; visible: false
    Rectangle { id: rect; anchors.fill: parent
      color: "#d9120f1b"; border { width: 2; color: "#d953c1dc" }
      property real animScale: 1.0; property real animScaleX: 1.0
      property real animOpacity: 1.0; property real animYOffset: 0
      property real animRotation: 0
      opacity: rect.animOpacity
      transform: [
        Scale { origin.x: rect.width / 2; origin.y: rect.height / 2
          xScale: rect.animScaleX * rect.animScale; yScale: rect.animScale },
        Translate { y: rect.animYOffset },
        Rotation { angle: rect.animRotation; origin.x: rect.width / 2; origin.y: rect.height / 2 }
      ]
    }
  }

  SequentialAnimation { id: o0; ParallelAnimation {
    NumberAnimation { id: o_o; target: rect; property: "animOpacity" }
    NumberAnimation { id: o_s; target: rect; property: "animScale" }
    NumberAnimation { id: o_x; target: rect; property: "animScaleX" }
    NumberAnimation { id: o_y; target: rect; property: "animYOffset" }
    NumberAnimation { id: o_r; target: rect; property: "animRotation" }
  }}

  SequentialAnimation { id: c0; ParallelAnimation {
    NumberAnimation { id: c_o; target: rect; property: "animOpacity" }
    NumberAnimation { id: c_s; target: rect; property: "animScale" }
    NumberAnimation { id: c_x; target: rect; property: "animScaleX" }
    NumberAnimation { id: c_y; target: rect; property: "animYOffset" }
    NumberAnimation { id: c_r; target: rect; property: "animRotation" }
  } onStopped: { box.visible = false; rect.animScale = 1.0; rect.animOpacity = 1.0 }}

  function openIt() { if (box.visible) return; box.visible = true
    rect.animOpacity = 0; rect.animScaleX = 1; rect.animYOffset = 0; rect.animRotation = 0
    o_x.from = 1; o_x.to = 1; o_x.duration = 1; o_x.easing.type = Easing.Linear
    o_r.from = 0; o_r.to = 0; o_r.duration = 1; o_r.easing.type = Easing.Linear
    rect.animScale = 0.10
    o_o.from = 0; o_o.to = 1; o_o.duration = 200; o_o.easing.type = Easing.Linear
    o_s.from = 0.10; o_s.to = 1.0; o_s.duration = 450; o_s.easing.type = Easing.OutBack
    o_y.from = 0; o_y.to = 0; o_y.duration = 1; o_y.easing.type = Easing.Linear
    o0.start() }

  function closeIt() { if (!box.visible) return
    c_x.from = 1; c_x.to = 1; c_x.duration = 1; c_x.easing.type = Easing.Linear
    c_r.from = 0; c_r.to = 0; c_r.duration = 1; c_r.easing.type = Easing.Linear
    c_o.from = 1; c_o.to = 0; c_o.duration = 120; c_o.easing.type = Easing.InQuad
    c_s.from = 1.0; c_s.to = 0.15; c_s.duration = 220; c_s.easing.type = Easing.InBack
    c_y.from = 0; c_y.to = 0; c_y.duration = 1; c_y.easing.type = Easing.Linear
    c0.start() }
}
