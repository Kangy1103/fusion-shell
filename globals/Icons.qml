pragma Singleton
import QtQuick
import Quickshell

QtObject {
  readonly property var appIconMap: ({
      "zen": "\ueb87",
      "vesktop": "\ueb71",
      "steam": "\ueaf2",
      "firefox": "\ueb87",
      "brave": "\ueb87",
      "brave-browser": "\ueb87",
      "chromium": "\ueb87",
      "chromium-browser": "\ueb87",
      "code": "\uec88",
      "codium": "\uec88",
      "com.mitchellh.ghostty": "\uec89",
      "ghostty": "\uec89",
      "com.mitchellh.ghostty": "\uec89",
      "foot": "\uec89",
      "kitty": "\uec89",
      "org.kde.dolphin": "\uec8c"
    })

  readonly property var catIconMap: ({
      "WebBrowser": "\ueb87",
      "Network": "\ueb71",
      "Development": "\uec88",
      "IDE": "\uec88",
      "TextEditor": "\uec8f",
      "Game": "\ueaf2",
      "FileManager": "\uec8c",
      "TerminalEmulator": "\uec89",
      "Audio": "\uead4",
      "Music": "\uead4",
      "Video": "\ueb10",
      "Graphics": "\ueb06",
      "System": "\uec8e"
    })

  function getAppIcon(appId) {
    if (appIconMap[appId])
      return appIconMap[appId];
    if (/^steam_app_\d+$/.test(appId))
      return "\ueaf2";
    var entry = DesktopEntries.heuristicLookup(appId);
    if (entry && entry.categories) {
      for (var i = 0; i < entry.categories.length; i++) {
        if (catIconMap[entry.categories[i]])
          return catIconMap[entry.categories[i]];
      }
    }
    return "\uec8a";
  }
}
