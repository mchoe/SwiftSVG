//
//  SVGCircle.swift
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


class SVGCircle: SVGShapeElement {
    
    var circleCenter = CGPoint.zero
    var circleRadius: CGFloat = 0
    var elementName: String {
        return "circle"
    }
    var svgLayer = CAShapeLayer()
    var supportedAttributes: [String : ((String) -> ())?] = [:]
    
    internal func radius(r: String) {
        guard let r = Double(lengthString: r) else {
            return
        }
        self.circleRadius = CGFloat(r)
    }
    
    internal func xCenter(x: String) {
        guard let x = Double(lengthString: x) else {
            return
        }
        self.circleCenter.x = CGFloat(x)
    }
    
    internal func yCenter(y: String) {
        guard let y = Double(lengthString: y) else {
            return
        }
        self.circleCenter.y = CGFloat(y)
    }
    
    func didProcessElement(in container: SVGContainerElement?) {
        guard let container = container else {
            return
        }
        let circlePath = UIBezierPath(arcCenter: self.circleCenter, radius: self.circleRadius, startAngle: 0, endAngle:CGFloat.pi * 2, clockwise: true)
        self.svgLayer.path = circlePath.cgPath
        container.containerLayer.addSublayer(self.svgLayer)
    }
}
