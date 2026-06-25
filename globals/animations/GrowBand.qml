import QtQuick

Item {
  id: root

  property Item targetItem: null
  property var window: null
  property bool closing: false
  signal openSesMe
  signal closeSesMe

  // openSesMe
  SequentialAnimation {
    id: openMe
    ParallelAnimation {
      NumberAnimation {
        id: o_o
        target: root.targetItem
        property: "animationOpacity"
      }
      NumberAnimation {
        id: o_s
        target: root.targetItem
        property: "animationScale"
      }
      NumberAnimation {
        id: o_x
        target: root.targetItem
        property: "animationScaleX"
      }
      NumberAnimation {
        id: o_y
        target: root.targetItem
        property: "animationYOffset"
      }
      NumberAnimation {
        id: o_r
        target: root.targetItem
        property: "animationRotation"
      }
    }
  }
  // closeSesMe
  SequentialAnimation {
    id: closeMe
    ParallelAnimation {
      NumberAnimation {
        id: c_o
        target: root.targetItem
        property: "animationOpacity"
      }
      NumberAnimation {
        id: c_s
        target: root.targetItem
        property: "animationScale"
      }
      NumberAnimation {
        id: c_x
        target: root.targetItem
        property: "animationScaleX"
      }
      NumberAnimation {
        id: c_y
        target: root.targetItem
        property: "animationYOffset"
      }
      NumberAnimation {
        id: c_r
        target: root.targetItem
        property: "animationRotation"
      }
    }
    onStopped: {
      root.window.visible = false;
      root.closing = false;
      root.closeSesMe();
    }
  }
  function open() {
    if (!targetItem || !window || window.visible)
      return;
    targetItem.animationOpacity = 0;
    targetItem.animationScaleX = 1;
    targetItem.animationYOffset = 0;
    targetItem.animationRotation = 0;
    o_x.from = 1;
    o_x.to = 1;
    o_x.duration = 1;
    o_x.easing.type = Easing.Linear;
    o_r.from = 0;
    o_r.to = 0;
    o_r.duration = 1;
    o_r.easing.type = Easing.Linear;
    // GrowBand opening settings ───
    targetItem.animationScale = 0.10;
    o_o.from = 0.45;
    o_o.to = 1;
    o_o.duration = 180;
    o_o.easing.type = Easing.Linear;
    o_s.from = 0.10;
    o_s.to = 1.0;
    o_s.duration = 550;
    o_s.easing.type = Easing.OutElastic;
    o_s.easing.amplitude = 0.5;
    o_s.easing.period = 0.35;
    o_y.from = 0;
    o_y.to = 0;
    o_y.duration = 1;
    o_y.easing.type = Easing.Linear;
    // End
    window.visible = true;
    openMe.start();
    root.openSesMe();
  }

  function close() {
    if (root.closing || !targetItem || !window || !window.visible)
      return;
    root.closing = true;
    c_x.from = 1;
    c_x.to = 1;
    c_x.duration = 1;
    c_x.easing.type = Easing.Linear;
    c_r.from = 0;
    c_r.to = 0;
    c_r.duration = 1;
    c_r.easing.type = Easing.Linear;
    // GrowBand closing settings ───
    c_o.from = 1;
    c_o.to = 0;
    c_o.duration = 120;
    c_o.easing.type = Easing.InQuad;
    c_s.from = 1.0;
    c_s.to = 0.10;
    c_s.duration = 200;
    c_s.easing.type = Easing.InQuad;
    c_y.from = 0;
    c_y.to = 0;
    c_y.duration = 1;
    c_y.easing.type = Easing.Linear;
    // End
    closeMe.start();
  }
}
