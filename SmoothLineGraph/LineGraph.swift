//
//  SmoothLineGraph.swift
//  Cast
//
//  Created by Matt Selby on 7/8/20.
//  Copyright © 2020 Matt Selby. All rights reserved.
//

import SwiftUI

extension CGPoint{
    
    func translate(x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + x, y: self.y + y)
    }
    
    func translateX(x: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + x, y: self.y)
    }
    
    func translateY(y: CGFloat) -> CGPoint {
        return CGPoint(x: self.x, y: self.y + y)
    }
    
    func invertY() -> CGPoint {
        return CGPoint(x: self.x, y: -self.y)
    }
    
    func xAxis() -> CGPoint {
        return CGPoint(x: 0, y: self.y)
    }
    
    func yAxis() -> CGPoint {
        return CGPoint(x: self.x, y: 0)
    }
    
    func addTo(a: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + a.x, y: self.y + a.y)
    }
    
    func deltaTo(a: CGPoint) -> CGPoint {
        return CGPoint(x: self.x - a.x, y: self.y - a.y)
    }
    
    func multiplyBy(value:CGFloat) -> CGPoint{
        return CGPoint(x: self.x * value, y: self.y * value)
    }
    
    func length() -> CGFloat {
        return CGFloat(sqrt(CDouble(
            self.x*self.x + self.y*self.y
            )))
    }
    
    func normalize() -> CGPoint {
        let l = self.length()
        return CGPoint(x: self.x / l, y: self.y / l)
    }
}

extension Path {
    
    func smoothedPathFromPoints(points: [CGPoint]) -> Path {
        
        return Path { path in
            for i in 1..<points.count - 2 {
                let alpha = CGFloat(0.5)
                let p0 = i - 1 < 0 ? CGPoint(x: 0, y: 0) : points[i - 1]
                let p1 = points[i]
                let p2 = points[(i + 1) % points.count]
                let p3 = points[(i + 1) % points.count + 1]
                
                let d1 = p1.deltaTo(a: p0).length()
                let d2 = p2.deltaTo(a: p1).length()
                let d3 = p3.deltaTo(a: p2).length()
                
                var b1 = p2.multiplyBy(value: pow(d1, 2 * alpha))
                b1 = b1.deltaTo(a: p0.multiplyBy(value: pow(d2, 2 * alpha)))
                b1 = b1.addTo(a: p1.multiplyBy(value: 2 * pow(d1, 2 * alpha) + 3 * pow(d1, alpha) * pow(d2, alpha) + pow(d2, 2 * alpha)))
                b1 = b1.multiplyBy(value: 1.0 / (3 * pow(d1, alpha) * (pow(d1, alpha) + pow(d2, alpha))))
                
                var b2 = p1.multiplyBy(value: pow(d3, 2 * alpha))
                b2 = b2.deltaTo(a: p3.multiplyBy(value: pow(d2, 2 * alpha)))
                b2 = b2.addTo(a: p2.multiplyBy(value: 2 * pow(d3, 2 * alpha) + 3 * pow(d3, alpha) * pow(d2, alpha) + pow(d2, 2 * alpha)))
                b2 = b2.multiplyBy(value: 1.0 / (3 * pow(d3, alpha) * (pow(d3, alpha) + pow(d2, alpha))))
                if i == 1 {
                    path.move(to: p1)
                }
                path.addCurve(to: p2, control1: b1, control2: b2)
            }
        }
    }
}

struct LineGraph: View {
    var points: [CGPoint]
    var minX: CGFloat {
        let minXPoint = points.min(by: { (a, b) -> Bool in
            return a.x < b.x
        })
        if let minXPoint = minXPoint {
            return minXPoint.x
        } else {
            return 0
        }
    }
    var maxX: CGFloat {
        let maxXPoint = points.max(by: { (a, b) -> Bool in
            return a.x < b.x
            
        })
        if let maxXPoint = maxXPoint {
            return maxXPoint.x
        } else {
            return 0
        }
    }
    var minY: CGFloat {
        let minYPoint = points.min(by: { (a, b) -> Bool in
            return a.y < b.y
        })
        if let minYPoint = minYPoint {
            return minYPoint.y
        } else {
            return 0
        }
    }
    var maxY: CGFloat {
        let maxYPoint = points.max(by: { (a, b) -> Bool in
            return a.y < b.y
        })
        if let maxYPoint = maxYPoint {
            return maxYPoint.y
        } else {
            return 0
        }
    }
    func graphPointsFor(geometry: GeometryProxy) -> [CGPoint] {
        print(self.maxX)
        print(self.minX)
        print(geometry.frame(in: .local).width)
        print(self.maxY)
        print(self.minY)
        print(geometry.frame(in: .local).height)
        let stepSizeX = geometry.frame(in: .local).width / (self.maxX - self.minX)
        let stepSizeY = geometry.frame(in: .local).height / (self.maxY - self.minY)
        var _points = self.points
        // Scale points to graph size
        _points = _points.map({
            (point: CGPoint) -> CGPoint in
            let xVal = ( point.x > 0 ? point.x - self.minX : point.x + self.minX ) * stepSizeX
            let yVal = ( point.y > 0 ? point.y - self.minY : point.y + self.minY ) * stepSizeY
            return CGPoint(x: xVal, y: yVal)
        })
        // Add start and end point (you need two additional points for Catmull-Rom smoothing)
        var p1 = _points[0]
        var p2 = _points[1]
        var yVal: CGFloat
        if p1.y == p2.y {
            yVal = p1.y
        } else if p1.y > p2.y {
            yVal = p1.y + p2.y
        } else {
            yVal = p1.y - p2.y
        }
        let startPoint: CGPoint = CGPoint(x: p1.x - p2.x, y: yVal)
        _points.insert(startPoint, at: 0)
        p1 = _points[_points.count - 1]
        p2 = _points[_points.count - 2]
        if p1.y == p2.y {
            yVal = p1.y
        } else if p1.y > p2.y {
            yVal = p1.y + p2.y
        } else {
            yVal = p1.y - p2.y
        }
        let endPoint: CGPoint = CGPoint(x: p1.x + p2.x, y: yVal)
        _points.append(endPoint)
//        _points.insert(CGPoint(x: -stepSizeX, y: -stepSizeY), at: 0)
//        _points.append(CGPoint(x: geometry.frame(in: .local).width + stepSizeX, y: geometry.frame(in: .local).height + stepSizeY))
        return _points
    }
    var body: some View {
        GeometryReader { geometry in
            Path.init().smoothedPathFromPoints(points: self.graphPointsFor(geometry: geometry))
                .stroke(Color.blue)
                .rotationEffect(.degrees(180), anchor: .center)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        }
    }
}

struct LineGraph_Previews: PreviewProvider {
    static var previews: some View {
        LineGraph(points: [
            CGPoint(x: 1, y: 40),
            CGPoint(x: 2, y: 40),
            CGPoint(x: 3, y: 40),
            CGPoint(x: 6, y: 27),
            CGPoint(x: 10, y: 100)
        ]).frame(width: 300, height: 300, alignment: .center)
    }
}
