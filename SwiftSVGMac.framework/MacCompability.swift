//
//  MacCompability.swift
//  SwiftSVG
//
//  Created by Matthias Schlemm on 26/06/15.
//  Copyright (c) 2015 Strauss LLC. All rights reserved.
//

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
            if let l = layer {
                return l
            } else {
                layer = CALayer()
                layer?.frame = self.bounds
                wantsLayer = true
                return layer!
            }
        #endif
    }
}

#if os(OSX)
extension NSBezierPath {
    var addLineToPoint:((NSPoint)->Void) {
        return lineToPoint
    }
    
    var addCurveToPoint:((NSPoint, controlPoint1:NSPoint, controlPoint2:NSPoint)->Void) {
        return curveToPoint
    }
    
    func addQuadCurveToPoint(endPoint: NSPoint, controlPoint: NSPoint) {
        self.addCurveToPoint(endPoint,
            controlPoint1: CGPointMake(
                (controlPoint.x - currentPoint.x) * (2.0 / 3.0) +  currentPoint.x,
                (controlPoint.y - currentPoint.y) * (2.0 / 3.0) + currentPoint.y
            ),
        controlPoint2: CGPointMake(
            (controlPoint.x - endPoint.x) * (2.0 / 3.0) +  endPoint.x,
            (controlPoint.y - endPoint.y) * (2.0 / 3.0) +  endPoint.y
        ))
    }
    
    var CGPath:CGPathRef? {
        var immutablePath:CGPathRef? = nil
        let numElements = self.elementCount
        if numElements > 0 {
            let path = CGPathCreateMutable()
            let points = NSPointArray.alloc(3)
            var didClosePath = true
            
            for i in 0..<numElements {
                switch(self.elementAtIndex(i, associatedPoints: points)) {
                case .MoveToBezierPathElement:
                    CGPathMoveToPoint(path, nil, points[0].x, points[0].y)
                case .LineToBezierPathElement:
                    CGPathAddLineToPoint(path, nil, points[0].x, points[0].y);
                    didClosePath = false;
                case .CurveToBezierPathElement:
                    CGPathAddCurveToPoint(path, nil, points[0].x, points[0].y,
                        points[1].x, points[1].y,
                        points[2].x, points[2].y);
                    didClosePath = false;
                case .ClosePathBezierPathElement:
                    CGPathCloseSubpath(path);
                    didClosePath = true;
                }
            }
            if !didClosePath {
                CGPathCloseSubpath(path)
            }
            immutablePath = CGPathCreateCopy(path)
            points.dealloc(3)
        }
        return immutablePath
    }

}
#endif
