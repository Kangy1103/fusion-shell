pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import Quickshell

PopupWindow {
  id: root
  color: "transparent"
  implicitWidth: Math.max(180, (menuStack.currentItem?.maxItemWidth ?? 0) + 8)
  implicitHeight: Math.max(1, (menuStack.currentItem?.implicitHeight ?? 0) + 8)
  required property QtObject handle
  required property var theme
  onVisibleChanged: {
    if (visible) {
      menuStack.clear();
      var page = subMenuPage.createObject(menuStack, {
        handle: root.handle,
        depth: 1,
        theme: root.theme
      });
      menuStack.push(page);
    } else {
      menuStack.clear();
    }
  }

  Rectangle {
    anchors.fill: parent
    color: root.theme.bg
    radius: 6
    border.color: root.theme.borderTransparent
    border.width: 1
  }

  Item {
    anchors.fill: parent
    anchors.margins: 4

    StackView {
      id: menuStack
      anchors.fill: parent
      implicitWidth: currentItem?.implicitWidth ?? 0
      implicitHeight: currentItem?.implicitHeight ?? 0

      Component {
        id: subMenuPage
        SubMenu {
          handle: root.handle
          depth: 1
          theme: root.theme
        }
      }
    }
  }
  component SubMenu: Column {
    id: subMenuRoot
    required property var handle
    required property var theme
    property int depth: 1
    spacing: 0
    property real maxItemWidth: 120

    QsMenuOpener {
      id: opener
      menu: subMenuRoot.handle
    }

    Item {
      height: subMenuRoot.depth > 1 ? 26 : 0
      visible: subMenuRoot.depth > 1
      clip: true
      Rectangle {
        anchors.fill: parent
        color: subMenuRoot.theme.hoverBgTransparent
        Text {
          anchors.left: parent.left
          anchors.leftMargin: 8
          anchors.verticalCenter: parent.verticalCenter
          text: "← Back"
          color: root.theme.text
          font.pointSize: 11
        }
        MouseArea {
          anchors.fill: parent
          onClicked: menuStack.pop()
        }
      }
    }

    Repeater {
      model: opener.children

      delegate: Item {
        id: delegateRoot
        required property var modelData
        implicitWidth: modelData.isSeparator ? 120 : Math.min(400, Math.max(120, labelMetrics.width + 40))
        anchors.left: parent ? parent.left : undefined
        anchors.right: parent ? parent.right : undefined
        property real textHeight: 18
        height: modelData.isSeparator ? 8 : Math.max(30, textHeight + 8)

        TextMetrics {
          id: labelMetrics
          text: delegateRoot.modelData.text
          font.pointSize: 11
        }

        Component.onCompleted: {
          subMenuRoot.maxItemWidth = Math.max(subMenuRoot.maxItemWidth, implicitWidth);
        }
        onImplicitWidthChanged: {
          subMenuRoot.maxItemWidth = Math.max(subMenuRoot.maxItemWidth, implicitWidth);
        }

        Rectangle {
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter
          height: 1
          visible: delegateRoot.modelData.isSeparator
          color: root.theme.borderTransparent
        }

        Rectangle {
          anchors.fill: parent
          visible: !delegateRoot.modelData.isSeparator
          color: ma.containsMouse ? root.theme.hoverBg : root.theme.bg
          radius: 6

          Text {
            id: label
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: delegateRoot.modelData.text
            color: !delegateRoot.modelData.enabled ? subMenuRoot.theme.textDimmed : ma.containsMouse ? subMenuRoot.theme.hoverText : subMenuRoot.theme.text
            font.pointSize: 11
            wrapMode: Text.WordWrap
            width: Math.max(0, parent.width - 30)
            onImplicitHeightChanged: delegateRoot.textHeight = implicitHeight
          }

          Text {
            anchors.right: parent.right
            anchors.rightMargin: 6
            text: ">"
            color: subMenuRoot.theme.textMuted
            font.pointSize: 14
            visible: delegateRoot.modelData.hasChildren
          }
        }

        MouseArea {
          id: ma
          hoverEnabled: true
          anchors.fill: parent
          onClicked: {
            if (delegateRoot.modelData.hasChildren) {
              var page = subMenuPage.createObject(menuStack, {
                handle: delegateRoot.modelData,
                depth: subMenuRoot.depth + 1,
                theme: subMenuRoot.theme
              });
              menuStack.push(page);
            } else {
              delegateRoot.modelData.triggered();
              root.visible = false;
            }
          }
        }
      }
    }
  }
}
