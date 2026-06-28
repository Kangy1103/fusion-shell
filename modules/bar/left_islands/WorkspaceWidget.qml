import QtQuick
import QtQuick.Layouts
import FusionShell.Internal.Niri
import "../../../globals/animations"
import "../../../globals"

Item {
  id: root
  required property var theme

  implicitHeight: 32
  implicitWidth: workspaceRow.implicitWidth

  RowLayout {
    id: workspaceRow
    anchors.verticalCenter: parent.verticalCenter
    spacing: 2

    Repeater {
      model: NiriIpc.currentOutputWorkspaces

      Rectangle {
        id: pill
        implicitWidth: pillRow.implicitWidth + 12
        implicitHeight: 28
        radius: 8
        color: pill.isActive ? root.theme.bgTransparent : "transparent"
        border.color: root.theme.borderTransparent
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
            pill.isActive = Number(pill.ws.id) === NiriIpc.focusedWorkspaceId;
          }
          function onWorkspacesChanged() {
            pill.isActive = Number(pill.ws.id) === NiriIpc.focusedWorkspaceId;
          }
        }

        Component.onCompleted: {
          pill.isActive = Number(pill.ws.id) === NiriIpc.focusedWorkspaceId;
        }

        MouseArea {
          anchors.fill: parent
          onClicked: NiriIpc.action("FocusWorkspace", [pill.ws.idx])
        }

        Rectangle {
          anchors.right: parent.right
          anchors.rightMargin: -1
          anchors.verticalCenter: parent.verticalCenter
          width: 1
          height: parent.height - 8
          color: root.theme.borderTransparent
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
            color: pill.isActive ? root.theme.text : root.theme.textDimmed
            font.pointSize: 14
            Layout.alignment: Qt.AlignVCenter
          }

          Repeater {
            // winRev >= 0 force check on window change (QML dependency trick)
            model: pill.isActive && pill.winRev >= 0 ? NiriIpc.getWindowsByWorkspaceId(pill.ws.id) : []

            Text {
              font.family: NiriIpc.qlementineFontFamily
              font.pointSize: 16
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
