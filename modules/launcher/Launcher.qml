pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Io
import "../../globals/animations"

PopupWindow {
  id: launcher
  property font baseFont: Qt.font({
    family: "JetBrainsMono Nerd Font",
    pointSize: 14
  })
  property font titleFont: Qt.font({
    family: "JetBrainsMono Nerd Font",
    pointSize: 18,
    weight: Font.Bold
  })
  required property var theme

  // Cycling launcher messages with specific icons
  property list<var> prompts: [
    {
      icon: Qt.resolvedUrl("../../icons/dragon-radar.png"),
      text: "Dragon Radar"
    },
    {
      icon: Qt.resolvedUrl("../../icons/9000.png"),
      text: "IT'S OVER 9000!!!"
    },
    {
      icon: Qt.resolvedUrl("../../icons/scouter.png"),
      text: "What does your scouter say?"
    }
  // Summon shenron
  // Find other iconic sayings I guess?
  ]
  property int promptIndex: 0
  // End

  // Apps to hide from the launcher
  property list<string> hiddenApps: [
    // Audio plugins
    "lsp-plugins", "com.zamaudio.zamautosat", "com.zamaudio.zamaximx2", "com.zamaudio.zamcomp", "com.zamaudio.zamcompx2", "com.zamaudio.zamdelay", "com.zamaudio.zamdynamiceq", "com.zamaudio.zameq2", "com.zamaudio.zamgate", "com.zamaudio.zamgatex2", "com.zamaudio.zamgeq31", "com.zamaudio.zamgrains", "com.zamaudio.zamheadx2", "com.zamaudio.zamnoise", "com.zamaudio.zamphono", "com.zamaudio.zamtube", "com.zamaudio.zamulticomp", "com.zamaudio.zamulticompx2", "com.zamaudio.zamverb",
    // Java tools
    "jconsole-java21-openjdk", "jshell-java21-openjdk",
    // Qt dev tools
    "assistant", "designer", "linguist", "qdbusviewer"]
  // End

  // App usage tracking
  FileView {
    id: usageFile
    path: Quickshell.dataPath("launch-counts.json")
    watchChanges: true
    onFileChanged: reload()
    onAdapterUpdated: writeAdapter()

    JsonAdapter {
      id: launchCount
      property var counts: ({})
    }
  }

  function recordLaunch(appId: string) {
    let c = Object.assign({}, launchCount.counts);
    c[appId] = (c[appId] || 0) + 1;
    launchCount.counts = c;
    usageFile.writeAdapter();
  }
  function toggle() {
    if (visible)
      launcherAnimation.close();
    else
      launcherAnimation.open();
  }

  required property QtObject anchorWindow

  signal appLaunched

  grabFocus: true
  visible: false
  implicitWidth: 1000
  implicitHeight: 600
  surfaceFormat.opaque: false

  BackgroundEffect.blurRegion: Region {
    item: blurTarget
  }

  anchor {
    window: anchorWindow
    rect.x: anchorWindow.width / 2 - width / 2
    rect.y: (screen.height - height) / 2
  }

  onVisibleChanged: {
    if (visible) {
      searchField.forceActiveFocus();
      promptIndex = Math.floor(Math.random() * prompts.length);
    }
  }

  SoftExpand {
    id: launcherAnimation
    targetItem: blurRect
    window: launcher
  }

  Rectangle {
    id: blurRect
    anchors.fill: parent
    color: launcher.theme.bgTransparent
    radius: 28
    border.width: 2
    border.color: launcher.theme.borderTransparent
    // Launcher animiation
    property real animationScale: 1.0
    property real animationScaleX: 1.0
    property real animationOpacity: 1.0
    property real animationYOffset: 0
    property real animationRotation: 0

    opacity: animationOpacity
    transform: [
      Scale {
        origin.x: blurRect.width / 2
        origin.y: blurRect.height / 2
        xScale: blurRect.animationScaleX * blurRect.animationScale
        yScale: blurRect.animationScale
      },
      Translate {
        y: blurRect.animationYOffset
      },
      Rotation {
        angle: blurRect.animationRotation
        origin.x: blurRect.width / 2
        origin.y: blurRect.height / 2
      }
    ]

    Item {
      id: blurTarget
      anchors.centerIn: parent
      width: parent.width * parent.animationScale * parent.animationOpacity
      height: parent.height * parent.animationScale * parent.animationOpacity
    }

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 25

      RowLayout {
        Layout.fillWidth: true

        // The icon before the search placeholder text
        Image {
          source: launcher.prompts[launcher.promptIndex].icon
          sourceSize.width: 38
          sourceSize.height: 38
          Layout.rightMargin: 8
          Layout.alignment: Qt.AlignVCenter
        }

        TextInput {
          id: searchField
          focus: true
          color: launcher.theme.text
          font: launcher.baseFont
          Layout.fillWidth: true
          Keys.onEscapePressed: launcherAnimation.close()

          // Search bar text
          Text {
            anchors.fill: parent
            text: launcher.prompts[launcher.promptIndex].text
            color: launcher.theme.text
            font.italic: true
            visible: !parent.text
            Layout.alignment: Qt.AlignVCenter
          }
        }
      }

      // Divider between search and apps
      Image {
        source: Qt.resolvedUrl("../../icons/gogeta-divider.png")
        Layout.fillWidth: true
        Layout.topMargin: 0
        Layout.bottomMargin: 0
        Layout.preferredHeight: 50
        fillMode: Image.PreserveAspectFit
      }

      // Two colum app list
      RowLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true

        //Left all apps
        ColumnLayout {
          Layout.fillWidth: true
          Layout.preferredWidth: 0
          Layout.fillHeight: true

          Text {
            text: "All Capsules"
            color: launcher.theme.text
            font.family: launcher.baseFont.family
            font.bold: true
            Layout.bottomMargin: 4
          }

          ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            model: ScriptModel {
              values: [...DesktopEntries.applications.values].filter(e => e != null && !launcher.hiddenApps.includes(e.id)).sort((a, b) => a.name.localeCompare(b.name))
            }

            delegate: Rectangle {
              required property var modelData
              implicitWidth: ListView.view.width
              implicitHeight: 36
              height: visible ? implicitHeight : 0
              radius: 8
              color: ma.containsMouse ? launcher.theme.hoverBgTransparent : "transparent"
              visible: searchField.text.length === 0 || modelData.name.toLowerCase().includes(searchField.text.toLowerCase())

              RowLayout {
                anchors.fill: parent

                IconImage {
                  source: Quickshell.iconPath(modelData.icon)
                  implicitSize: 36
                  Layout.alignment: Qt.AlignVCenter
                }

                Text {
                  text: modelData.name
                  color: ma.containsMouse ? launcher.theme.hoverText : launcher.theme.text
                  font.family: launcher.baseFont.family
                  Layout.fillWidth: true
                  Layout.alignment: Qt.AlignVCenter
                }
              }

              MouseArea {
                id: ma
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                  modelData.execute();
                  recordLaunch(modelData.id);
                  launcherAnimation.close();
                  appLaunched();
                }
              }
            }
          }
        }

        //Verticale divider
        Rectangle {
          Layout.fillHeight: true
          Layout.leftMargin: 8
          Layout.rightMargin: 8
          Layout.preferredWidth: 1
          color: launcher.theme.borderTransparent
        }

        // Right most used
        ColumnLayout {
          Layout.fillWidth: true
          Layout.preferredWidth: 0
          Layout.fillHeight: true

          Text {
            text: "Common Capsules"
            color: launcher.theme.text
            font.family: launcher.baseFont.family
            font.bold: true
            Layout.bottomMargin: 4
          }

          ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            model: ScriptModel {
              values: [...DesktopEntries.applications.values].filter(e => e != null && (launchCount.counts[e.id] || 0) > 0).sort((a, b) => (launchCount.counts[b.id] || 0) - (launchCount.counts[a.id] || 0)).slice(0, 8)
            }

            delegate: Rectangle {
              required property var modelData
              implicitWidth: ListView.view.width
              implicitHeight: 36
              height: visible ? implicitHeight : 0
              radius: 8
              color: mau.containsMouse ? launcher.theme.hoverBgTransparent : "transparent"
              visible: true

              RowLayout {
                anchors.fill: parent

                IconImage {
                  source: Quickshell.iconPath(modelData.icon)
                  implicitSize: 36
                  Layout.alignment: Qt.AlignVCenter
                }

                Text {
                  text: modelData.name
                  color: mau.containsMouse ? launcher.theme.hoverText : launcher.theme.text
                  font.family: launcher.baseFont.family
                  Layout.fillWidth: true
                  Layout.alignment: Qt.AlignVCenter
                }
              }

              MouseArea {
                id: mau
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                  modelData.execute();
                  recordLaunch(modelData.id);
                  launcherAnimation.close();
                  appLaunched();
                }
              }
            }
          }
        }
      }
    }
  }
}
