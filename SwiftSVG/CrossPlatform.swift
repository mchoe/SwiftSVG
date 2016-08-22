//
//  CrossPlatform.swift
//  SwiftSVG
//
//  Copyright (c) 2015 Michael Choe
//  http://www.straussmade.com/
//  http://www.twitter.com/_mchoe
//  http://www.github.com/mchoe
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

import Foundation

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
    public typealias UIView = NSView
    public typealias UIBezierPath = NSBezierPath
    public typealias UIColor = NSColor
#endif

extension UIView {
    var nonOptionalLayer:CALayer {
        #if os(iOS)
            return self.layer
        #elseif os(OSX)
            if let l = self.layer {
                return l
            } else {
                self.layer = CALayer()
                self.layer?.frame = self.bounds
                let flip = CATransform3DMakeScale(1.0, -1.0, 1.0)
                let translate = CATransform3DMakeTranslation(0.0, self.bounds.size.height, 1.0)
                self.layer?.sublayerTransform = CATransform3DConcat(flip, translate)
                self.wantsLayer = true
                return self.layer!
            }
        #endif
    }
}

#if os(OSX)
    public extension NSBezierPath {
        var addLineToPoint:((NSPoint)->Void) {
            return line
        }
        
        var addCurveToPoint:(((NSPoint, _ controlPoint1:NSPoint, _ controlPoint2:NSPoint)->Void)) {
            return curve
        }
        
        func addQuadCurveToPoint(endPoint: NSPoint, controlPoint: NSPoint) {
            self.addCurveToPoint(endPoint, CGPoint(
                    x: (controlPoint.x - currentPoint.x) * (2.0 / 3.0) +  currentPoint.x,
                    y: (controlPoint.y - currentPoint.y) * (2.0 / 3.0) + currentPoint.y
                ),
                CGPoint(
                    x: (controlPoint.x - endPoint.x) * (2.0 / 3.0) +  endPoint.x,
                    y: (controlPoint.y - endPoint.y) * (2.0 / 3.0) +  endPoint.y
                )
            )
        }
        
        var cgPath:CGPath? {
            var immutablePath:CGPath? = nil
            let numElements = self.elementCount
            if numElements > 0 {
                let path = CGMutablePath()
                let points = NSPointArray.allocate(capacity: 3)
                var didClosePath = true
                
                for i in 0..<numElements {
                    switch(self.element(at: i, associatedPoints: points)) {
                    case .moveToBezierPathElement:
                      path.move(to: CGPoint(x: points[0].x, y: points[0].y))
                    case .lineToBezierPathElement:
                      path.addLine(to: CGPoint(x: points[0].x, y: points[0].y));
                      didClosePath = false;
                    case .curveToBezierPathElement:
                      path.addCurve(
                          to: CGPoint(x: points[0].x, y: points[0].y),
                          control1: CGPoint(x: points[1].x, y: points[1].y),
                          control2: CGPoint(x: points[2].x, y: points[2].y)
                      );
                      didClosePath = false;
                    case .closePathBezierPathElement:
                        path.closeSubpath();
                        didClosePath = true;
                    }
                }
                if !didClosePath {
                    path.closeSubpath()
                }
                immutablePath = path.copy()
                points.deallocate(capacity: 3)
            }
            return immutablePath
        }
        
    }
#endif
