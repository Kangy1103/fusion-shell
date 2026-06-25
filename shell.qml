import QtQuick
import Quickshell
import Quickshell.Wayland
import "modules/bar"
import "modules/launcher"
import "modules"

PanelWindow {
  id: root
  implicitHeight: 50
  color: "transparent"
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

  anchors {
    top: true
    left: true
    right: true
  }

  Colours {
    id: colours
  }

  FontLoader {
    id: qlementineFont
    source: Qt.resolvedUrl("assets/fonts/Qlementine.ttf")
  }

  Bar {
    theme: colours
    anchors.fill: parent
    anchors.leftMargin: 10
    anchors.rightMargin: 10
    clock: clock
    onOpenSesMe: launcher.toggle()
  }

  Launcher {
    id: launcher
    theme: colours
    color: "transparent"
    anchorWindow: root
  }

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
}
