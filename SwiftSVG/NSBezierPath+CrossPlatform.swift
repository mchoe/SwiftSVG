//
//  NSBezierPath+CrossPlatform.swift
//  SwiftSVG
//
//  Created by Michael Choe on 1/5/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import AppKit

public extension NSBezierPath {
    
    var cgPath: CGPath {
        get {
            let path = CGMutablePath()
            var points = NSPointArray.allocate(capacity: 3)
            
            for i in 0 ..< self.elementCount {
                let type = self.element(at: i, associatedPoints: points)
                switch type {
                case .moveToBezierPathElement:
                    path.move(to: points[0])
                case .lineToBezierPathElement:
                    path.addLine(to: points[0])
                case .curveToBezierPathElement:
                    path.addCurve(to: points[2], control1: points[0], control2: points[1])
                case .closePathBezierPathElement:
                    path.closeSubpath()
                }
            }
            return path
        }
    }
    
    public func addLine(to point: NSPoint) {
        self.line(to: point)
    }
    
    public func addCurve(to point: NSPoint, controlPoint1: NSPoint, controlPoint2: NSPoint) {
        self.curve(to: point, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }
    
    public func addQuadCurve(to point: NSPoint, controlPoint: NSPoint) {
        self.curve(to: point,
                   controlPoint1: NSPoint(
                    x: (controlPoint.x - self.currentPoint.x) * (2.0 / 3.0) + self.currentPoint.x,
                    y: (controlPoint.y - self.currentPoint.y) * (2.0 / 3.0) + self.currentPoint.y),
                   controlPoint2: NSPoint(
                    x: (controlPoint.x - point.x) * (2.0 / 3.0) +  point.x,
                    y: (controlPoint.y - point.y) * (2.0 / 3.0) +  point.y))
    }
    
}
