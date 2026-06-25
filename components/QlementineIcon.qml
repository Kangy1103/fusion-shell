import QtQuick
import FusionShell.Internal.Niri

Text {
    id: root

    property real size: 18

    font.family: NiriIpc.qlementineFontFamily
    font.pixelSize: size
    color: "#e0dce8"
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
}
