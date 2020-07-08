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

![screenshot](Resources/screenshot.png)
