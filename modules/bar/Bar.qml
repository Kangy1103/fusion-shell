import QtQuick // Makes types like Item, Rectangle etc available
import QtQuick.Layouts // Makes types like RowLayout available
import "../../globals/animations" // Import aniamtions
import "left_islands"
import "center_islands"
import "right_islands"

Item {
  id: bar_islands

  required property var clock
  required property var theme
  signal openSesMe

  // Left island - Launcher.qml
  Rectangle {
    id: launcherIsland
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.topMargin: 4
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 4
    width: leftRow.implicitWidth + 16
    radius: 8
    color: bar_islands.theme.bg
    border.color: bar_islands.theme.border
    border.width: 1

    RowLayout {
      id: leftRow
      anchors.left: parent.left
      anchors.leftMargin: 8
      anchors.verticalCenter: parent.verticalCenter
      spacing: 4
      AppsButton {
        theme: bar_islands.theme
        onClicked: bar_islands.openSesMe()
      }
    }
  }

  // Workspaces island
  Rectangle {
    id: workspacesIsland
    anchors.left: launcherIsland.right
    anchors.leftMargin: 4
    anchors.top: parent.top
    anchors.topMargin: 4
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 4
    width: workspaceRow.implicitWidth + 16
    radius: 8
    color: bar_islands.theme.bg
    border.color: bar_islands.theme.border
    border.width: 1

    RowLayout {
      id: workspaceRow
      anchors.left: parent.left
      anchors.leftMargin: 8
      anchors.verticalCenter: parent.verticalCenter
      spacing: 4
      WorkspaceWidget {
        theme: bar_islands.theme
      }
    }
  }

  // Center island - Workspaces, maybe clock, unsure right now
  Rectangle {
    id: centerIsland
    clip: true
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    height: 36
    width: centerRow.implicitWidth + 16
    radius: 8
    color: bar_islands.theme.bg
    border.color: bar_islands.theme.border
    border.width: 1
    visible: centerRow.implicitWidth > 0

    RowLayout {
      id: centerRow
      anchors.centerIn: parent
      spacing: 4
      //  NOTE: This is where any widgets will go
      ActiveWindow {
        theme: bar_islands.theme
      }
    }
  }

  // Right islands - Clock, tray, again, early days
  Rectangle {
    id: trayIsland
    anchors.right: clockIsland.left
    anchors.rightMargin: 4
    anchors.top: parent.top
    anchors.topMargin: 4
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 4
    width: trayRow.implicitWidth + 16
    radius: 8
    color: bar_islands.theme.bg
    border.color: bar_islands.theme.border
    border.width: 1

    RowLayout {
      id: trayRow
      anchors.left: parent.left
      anchors.leftMargin: 8
      anchors.verticalCenter: parent.verticalCenter
      spacing: 4
      TrayWidget {
        theme: bar_islands.theme
      }
    }
  }

  Rectangle {
    id: clockIsland
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.topMargin: 4
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 4
    width: rightRow.implicitWidth + 16
    radius: 8
    color: bar_islands.theme.bg
    border.color: bar_islands.theme.border
    border.width: 1

    RowLayout {
      id: rightRow
      anchors.right: parent.right
      anchors.rightMargin: 8
      anchors.verticalCenter: parent.verticalCenter
      spacing: 4
      //  NOTE: Widgets go here
      ClockWidget {
        theme: bar_islands.theme
        clock: bar_islands.clock
      }
    }
  }
}
