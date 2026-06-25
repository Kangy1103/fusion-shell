pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Item {
  id: tray
  implicitWidth: trayRow.implicitWidth
  implicitHeight: trayRow.implicitHeight
  required property var theme
  property var activePopup: null

  Row {
    id: trayRow
    spacing: 4

    Repeater {
      model: SystemTray.items.values

      delegate: Item {
        id: delegateItem
        implicitWidth: 24
        implicitHeight: 24
        required property var modelData

        Image {
          anchors.fill: parent
          source: modelData.icon
          sourceSize.width: 20
          sourceSize.height: 20
          fillMode: Image.PreserveAspectFit
          asynchronous: true
        }

        TrayMenuPopup {
          id: menuPopup
          handle: modelData.menu
          visible: false
          grabFocus: true
          theme: tray.theme
          anchor {
            item: delegateItem
            edges: Edges.Bottom | Edges.Left
          }
        }

        Connections {
          target: menuPopup
          function onVisibleChanged() {
            if (!menuPopup.visible)
              tray.activePopup = null;
          }
        }

        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.LeftButton | Qt.RightButton
          onClicked: event => {
            if (event.button === Qt.LeftButton)
              modelData.activate();
            else if (modelData.hasMenu) {
              if (tray.activePopup && tray.activePopup !== menuPopup)
                tray.activePopup.visible = false;
              tray.activePopup = menuPopup;
              menuPopup.visible = true;
            } else
              modelData.secondaryActivate();
          }
        }
      }
    }
  }
}
