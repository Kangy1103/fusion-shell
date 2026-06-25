Created by Kangy w/ OpenCode AI Assistance
Version: 0.1.0-20260623

# Animation G2: Refined Breathe

Width spring + text crossfade + conditional vertical puff.

## Files to change

### Bar.qml — centre island

Add `Behavior on width`:

```qml
Rectangle {
    // ... existing properties ...
    Behavior on width {
      NumberAnimation { duration: 400; easing.type: Easing.OutBack }
    }
}
```

### ActiveWindow.qml — root Item

1. Add `clip: true`
2. Add `Behavior on implicitWidth`
3. Wrap the `RowLayout` content in a SequentialAnimation for crossfade
4. Add a `yScale` property + `transform: Scale` for the conditional puff

```qml
Item {
  id: root
  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight
  clip: true

  required property QtObject theme
  property string title: "Desktop"
  property string appId: ""
  property real yScale: 1.0

  transform: Scale {
    origin.x: root.width / 2
    origin.y: root.height / 2
    xScale: 1
    yScale: root.yScale
  }

  Behavior on implicitWidth {
    NumberAnimation { duration: 400; easing.type: Easing.OutBack }
  }

  // ... Process + Timer unchanged ...

  // Crossfade on title change
  onTitleChanged: {
    anim.restart()
  }

  SequentialAnimation {
    id: anim
    NumberAnimation { target: activeTitle; property: "opacity"; to: 0; duration: 100 }
    PropertyAction { target: activeTitle; property: "text"; value: root.title }
    NumberAnimation { target: activeTitle; property: "opacity"; to: 1; duration: 200 }
  }

  SequentialAnimation {
    id: puffAnim
    NumberAnimation { target: root; property: "yScale"; to: 1.06; duration: 180; easing.type: Easing.OutBack }
    NumberAnimation { target: root; property: "yScale"; to: 1.0; duration: 300; easing.type: Easing.OutQuad }
  }

  // Conditional puff: only if title actually changed
  onTitleChanged: {
    if (oldTitle !== title) puffAnim.restart()
  }

  RowLayout {
    id: row
    // ... existing content ...
  }
}
```

## Notes

- The `yScale` puff only fires when the title string actually changes (not on every 500ms poll).
- The width spring handles the bar resizing smoothly; the crossfade hides the content swap.
- Both `Behavior on implicitWidth` (ActiveWindow) and `Behavior on width` (Bar island) work together for a two-level smooth resize.
