//
//  SVGLine.swift
//  SwiftSVG
//
//  Created by Michael Choe on 6/4/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

class SVGLine: SVGShapeElement {
    
    var end = CGPoint.zero
    var start = CGPoint.zero
    
    var svgLayer = CAShapeLayer()
    var supportedAttributes: [String : (String) -> ()] = [:]
    
    internal func x1(x1: String) {
        guard let x1 = Double(x1) else {
            return
        }
        self.start.x = CGFloat(x1)
    }
    
    internal func x2(x2: String) {
        guard let x2 = Double(x2) else {
            return
        }
        self.end.x = CGFloat(x2)
    }
    
    internal func y1(y1: String) {
        guard let y1 = Double(y1) else {
            return
        }
        self.start.y = CGFloat(y1)
    }
    
    internal func y2(y2: String) {
        guard let y2 = Double(y2) else {
            return
        }
        self.end.y = CGFloat(y2)
    }
    
    func didProcessElement(in parentLayer: CALayer?) {
        guard let parentLayer = parentLayer else {
            return
        }
        let linePath = UIBezierPath()
        linePath.move(to: self.start)
        linePath.addLine(to: self.end)
        self.svgLayer.path = linePath.cgPath
        parentLayer.addSublayer(self.svgLayer)
    }
    
}
