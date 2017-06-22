//
//  SVGShapeElement.swift
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

protocol SVGShapeElement: SVGElement {
    var svgLayer: CAShapeLayer { get set }
}

enum LineJoin: String {
    case miter, round, bevel
}

enum LineCap: String {
    case butt, round, square
}

extension SVGShapeElement {
    
    var fillAndStrokeAttributes: [String : (String) -> ()] {
        return [
            "fill": self.fillHex,
            "fill-rule": self.fillRule,
            "opacity": self.opacity,
            "stroke": self.strokeColor,
            "stroke-linecap": self.strokeLineCap,
            "stroke-linejoin": self.strokeLineJoin,
            "stroke-miterlimit": self.strokeMiterLimit,
            "stroke-width": self.strokeWidth
        ]
    }
    
    internal func opacity(opacity: String) {
        guard let opacity = CGFloat(opacity) else {
            return
        }
        self.svgLayer.opacity = Float(opacity)
    }
    
    internal func fillHex(fillColor: String) {
        guard let fillColor = UIColor(svgString: fillColor) else {
            return
        }
        self.svgLayer.fillColor = fillColor.cgColor
    }
    
    internal func fillRule(fillRule: String) {
        guard fillRule == "evenodd" else {
            return
        }
        self.svgLayer.fillRule = kCAFillRuleEvenOdd
    }
    
    internal func strokeLineCap(lineCap: String) {
        switch lineCap {
        case kCALineCapButt, kCALineCapRound, kCALineCapSquare:
            self.svgLayer.lineCap = lineCap
        default:
            return
        }
    }
    
    internal func strokeColor(strokeColor: String) {
        guard let strokeColor = UIColor(svgString: strokeColor) else {
            return
        }
        self.svgLayer.strokeColor = strokeColor.cgColor
    }
    
    internal func strokeLineJoin(lineJoin: String) {
        switch lineJoin {
        case kCALineJoinBevel, kCALineJoinMiter, kCALineJoinRound:
            self.svgLayer.lineJoin = lineJoin
        default:
            return
        }
    }
    
    internal func strokeMiterLimit(miterLimit: String) {
        guard let miterLimit = CGFloat(miterLimit) else {
            return
        }
        self.svgLayer.miterLimit = miterLimit
    }
    
    internal func strokeWidth(strokeWidth: String) {
        guard let strokeWidth = CGFloat(strokeWidth) else {
            return
        }
        self.svgLayer.lineWidth = strokeWidth
    }
    
}

