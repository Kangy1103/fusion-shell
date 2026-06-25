Created by Kangy w/ OpenCode AI Assistance
Version: 0.1.0-20260623

# Animation P: Accordion

Island + text both squish horizontally to a sliver, content changes mid-squish, everything springs back open.

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
3. Add a `scaleX` property + `transform: Scale`
4. Use a SequentialAnimation triggered on title change that orchestrates:
   - Squish to 20% width
   - Swap text
   - Spring back open

```qml
Item {
  id: root
  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight
  clip: true

  required property QtObject theme
  property string title: "Desktop"
  property string appId: ""
  property real scaleX: 1.0

  transform: Scale {
    origin.x: root.width / 2
    origin.y: root.height / 2
    xScale: root.scaleX
    yScale: 1
  }

  Behavior on implicitWidth {
    NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
  }

  // ... Process + Timer unchanged ...

  onTitleChanged: {
    anim.restart()
  }

  SequentialAnimation {
    id: anim
    NumberAnimation { target: root; property: "scaleX"; to: 0.2; duration: 150; easing.type: Easing.InQuad }
    PropertyAction { target: activeTitle; property: "text"; value: root.title }
    NumberAnimation { target: root; property: "scaleX"; to: 1.0; duration: 400; easing.type: Easing.OutBack }
  }

  RowLayout {
    id: row
    // ... existing content ...
  }
}
```

## Notes

- The `scaleX` transform on the root Item squishes the entire widget (icon + text) horizontally.
- Text swaps while squished — invisible to the user.
- The OutBack spring open gives a satisfying "pop" feel.
- Width behavior on implicitWidth handles the bar resize smoothly in parallel.
- No opacity fade — content is always visible and scales with the island.
