//
//  NSBezierPath+CrossPlatform.swift
//  SwiftSVG
//
//
//  Created by Michael Choe on 1/5/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.




#if os(OSX)
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
#endif
