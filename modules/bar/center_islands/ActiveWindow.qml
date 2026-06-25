import QtQuick
import Quickshell
import Quickshell.Widgets
import "../../../globals/animations"
import FusionShell.Internal.Niri

Item {
  id: root
  clip: true
  implicitWidth: icon.implicitWidth + (icon.visible ? 6 : 0) + root.current.implicitWidth
  implicitHeight: Math.max(icon.implicitHeight, root.current.implicitHeight)
  required property var theme
  property string title: NiriIpc.focusedWindowTitle || ""
  property string appId: NiriIpc.focusedWindowClass || ""
  property bool isDesktop: root.appId === "" || root.appId === "Desktop"
  property Text current: textOne
  onTitleChanged: {
    const next = root.current === textOne ? textTwo : textOne;
    next.text = title;
    root.current = next;
  }
  Behavior on implicitWidth {
    SmoothWidth {}
  }

  IconImage {
    id: icon
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    visible: true
    source: root.isDesktop ? Quickshell.iconPath("user-desktop") : Quickshell.iconPath(root.appId)
    implicitSize: 24
  }

  Text {
    id: textOne
    text: "Desktop"
    anchors.left: icon.visible ? icon.right : parent.left
    anchors.leftMargin: icon.visible ? 6 : 0
    anchors.verticalCenter: parent.verticalCenter
    color: root.theme.text
    font.pointSize: 12
    elide: Text.ElideRight
    opacity: root.current === textOne ? 1 : 0
    width: implicitWidth
    Behavior on opacity {
      SmoothWidth {
        duration: 300
      }
    }
  }

  Text {
    id: textTwo
    anchors.left: icon.visible ? icon.right : parent.left
    anchors.leftMargin: icon.visible ? 6 : 0
    anchors.verticalCenter: parent.verticalCenter
    color: root.theme.text
    font.pointSize: 12
    elide: Text.ElideRight
    opacity: root.current === textTwo ? 1 : 0
    width: implicitWidth
    Behavior on opacity {
      SmoothWidth {
        duration: 300
      }
    }
  }
}
