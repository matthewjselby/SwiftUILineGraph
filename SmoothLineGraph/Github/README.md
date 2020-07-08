# SwiftUILineGraph
A smooth line graph written in SwiftUI

Given an array of CGPoints:

```swift
[
  CGPoint(x: 1, y: 1),
  CGPoint(x: 2, y: 40),
  CGPoint(x: 3, y: 10),
  CGPoint(x: 6, y: 27),
  CGPoint(x: 10, y: 50),
  CGPoint(x: 12, y: 30)
]
```

The LineGraph component will provide a smoothed line graph (smoothing based on Catmull-Rom splines):

![screenshot](SmoothLineGraph/Resources/screenshot.png)

Usage:

```swift
    LineGraph(points: [
        CGPoint(x: 1, y: 5),
        CGPoint(x: 2, y: 40),
        CGPoint(x: 3, y: 20),
        CGPoint(x: 6, y: 27),
        CGPoint(x: 8, y: 100),
        CGPoint(x: 11, y: 70)
    ])
```
A frame can be specified if desired:

```swift
    LineGraph(points: [
        CGPoint(x: 1, y: 5),
        CGPoint(x: 2, y: 40),
        CGPoint(x: 3, y: 20),
        CGPoint(x: 6, y: 27),
        CGPoint(x: 8, y: 100),
        CGPoint(x: 11, y: 70)
    ]).frame(width: 300, height: 100, alignment: .center)
```

The graph automatically adjusts to draw within the frame. The minimum value will be drawn at the bottom of the frame, while the maximum value will be drawn at the top of the frame.

TODO:

- [  ] Support negative values
- [  ] Support optional data labels for axes
- [  ] Add parameter for stroke color and width
- [  ] Add optional parameter for under-graph fill color
