import QtQuick
import QtQuick.Layouts
import FusionShell.Internal.Niri
import "../../../globals/animations"
import "../../../globals"
import "../../../components"

Item {
  id: root
  required property var theme

  implicitHeight: 32
  implicitWidth: workspaceRow.implicitWidth

  property string tooltipText: ""
  property Item tooltipTarget: null

  RowLayout {
    id: workspaceRow
    anchors.verticalCenter: parent.verticalCenter
    spacing: 2

    Repeater {
      model: NiriIpc.currentOutputWorkspaces

      Rectangle {
        id: pill
        implicitWidth: pillRow.implicitWidth + 12
        implicitHeight: 30
        radius: 8
        color: pill.isActive ? root.theme.bg : "transparent"
        border.color: root.theme.border
        border.width: pill.isActive ? 1 : 0
        clip: true

        readonly property int myIdx: {
          var list = NiriIpc.currentOutputWorkspaces;
          for (var i = 0; i < list.length; i++) {
            if (list[i].id === pill.ws.id)
              return i;
          }
          return -1;
        }

        Behavior on implicitWidth {
          SmoothWidth {}
        }

        readonly property var ws: modelData
        property int winRev: 0
        property bool isActive: false

        Connections {
          target: NiriIpc
          function onWindowsChanged() {
            pill.winRev++;
          }
          function onWindowOpenedOrChanged() {
            pill.winRev++;
          }
          function onFocusedWorkspaceChanged() {
            var nowActive = Number(pill.ws.id) === NiriIpc.focusedWorkspaceId;
            if (nowActive) {
              pill.isActive = true;
              holdTimer.stop();
              iconDupLayer.visible = false;
              iconDupRepeater.model = [];
            } else if (pill.isActive) {
              holdTimer.start();
            }
          }
          function onWorkspacesChanged() {
            var nowActive = Number(pill.ws.id) === NiriIpc.focusedWorkspaceId;
            if (nowActive) {
              pill.isActive = true;
              holdTimer.stop();
              iconDupLayer.visible = false;
              iconDupRepeater.model = [];
            } else if (pill.isActive) {
              holdTimer.start();
            }
          }
        }

        Component.onCompleted: {
          pill.isActive = Number(pill.ws.id) === NiriIpc.focusedWorkspaceId;
        }

        Timer {
          id: holdTimer
          interval: 150
          onTriggered: {
            var wins = NiriIpc.getWindowsByWorkspaceId(pill.ws.id);
            iconDupRepeater.model = wins;
            iconDupLayer.visible = true;
            pill.isActive = false;
            iconDupHideTimer.start();
          }
        }

        Timer {
          id: iconDupHideTimer
          interval: 350
          onTriggered: {
            iconDupLayer.visible = false;
            iconDupRepeater.model = [];
          }
        }

        MouseArea {
          anchors.fill: parent
          onClicked: NiriIpc.action("FocusWorkspace", [pill.ws.idx])
        }

        Rectangle {
          anchors.right: parent.right
          anchors.rightMargin: 0
          anchors.verticalCenter: parent.verticalCenter
          width: 1
          height: parent.height - 8
          color: root.theme.border
          visible: !pill.isActive && pill.myIdx >= 0 && pill.myIdx < NiriIpc.currentOutputWorkspaces.length - 1 && NiriIpc.currentOutputWorkspaces[pill.myIdx + 1].id !== NiriIpc.focusedWorkspaceId
        }

        RowLayout {
          id: pillRow
          anchors.left: parent.left
          anchors.leftMargin: 6
          anchors.verticalCenter: parent.verticalCenter
          spacing: 4

          Text {
            text: pill.ws.name ? pill.ws.name : (pill.ws.idx)
            color: pill.isActive ? root.theme.border : root.theme.textDimmed
            font.pointSize: 14
            Layout.alignment: Qt.AlignVCenter
          }

          Text {
            visible: liveIconRepeater.count > 0
            text: ":"
            color: root.theme.border
            font.pointSize: 14
            Layout.alignment: Qt.AlignVCenter
          }

          Repeater {
            id: liveIconRepeater
            // winRev >= 0 force check on window change (QML dependency trick)
            model: pill.isActive && pill.winRev >= 0 ? NiriIpc.getWindowsByWorkspaceId(pill.ws.id) : []

            Text {
              font.family: NiriIpc.qlementineFontFamily
              font.pointSize: 12
              text: Icons.getAppIcon(modelData.app_id)
              color: root.theme.vegitoAccent
              Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

              MouseArea {
                id: iconHover
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.NoButton
                onEntered: {
                  root.tooltipTarget = iconHover;
                  root.tooltipText = modelData.title ?? "";
                  tooltipTimer.restart();
                }
                onExited: {
                  if (root.tooltipTarget === iconHover) {
                    root.tooltipTarget = null;
                    root.tooltipText = "";
                    tooltipTimer.stop();
                    tooltipOverlay.visible = false;
                  }
                }
              }
            }
          }
        }

        // Fake icons for animation
        Rectangle {
          id: iconDupLayer
          anchors.fill: pillRow
          color: "transparent"
          visible: false

          RowLayout {
            id: iconDupRow
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4

            Text {
              text: pill.ws.name ? pill.ws.name : (pill.ws.idx)
              color: pill.isActive ? root.theme.text : root.theme.textDimmed
              font.pointSize: 14
              Layout.alignment: Qt.AlignVCenter
            }

            Repeater {
              id: iconDupRepeater
              model: []

              Text {
                font.family: NiriIpc.qlementineFontFamily
                font.pointSize: 12
                text: Icons.getAppIcon(modelData.app_id)
                color: root.theme.textMuted
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
              }
            }
          }
        }
      }
    }
  }
  Timer {
    id: tooltipTimer
    interval: 400
    onTriggered: {
      if (root.tooltipText !== "" && root.tooltipTarget !== null) {
        var gp = root.tooltipTarget.mapToItem(root, 0, 0);
        tooltipOverlay.x = gp.x + root.tooltipTarget.width + 6;
        tooltipOverlay.y = gp.y + root.tooltipTarget.height / 2 - tooltipOverlay.height / 2;
        if (tooltipOverlay.y < 0)
          tooltipOverlay.y = 0;
        if (tooltipOverlay.y + tooltipOverlay.height > root.height)
          tooltipOverlay.y = root.height - tooltipOverlay.height;
        tooltipOverlay.visible = true;
      }
    }
  }

  Rectangle {
    id: tooltipOverlay
    visible: false
    z: 999
    width: Math.min(tooltipLabel.implicitWidth + 16, 500)
    height: tooltipLabel.implicitHeight + 10
    radius: 6
    color: root.theme.bgTransparent
    border.color: root.theme.borderTransparent
    border.width: 1

    Text {
      id: tooltipLabel
      anchors.centerIn: parent
      width: parent.width - 16
      text: root.tooltipText
      color: root.theme.text
      font.pointSize: 10
      elide: Text.ElideRight
    }
  }
}
