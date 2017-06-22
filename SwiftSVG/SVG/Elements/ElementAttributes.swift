//
//  ElementAttributes.swift
//  SwiftSVG
//
//  Created by tarragon on 6/22/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif


protocol Fillable { }
protocol Strokable { }

enum LineJoin: String {
    case miter, round, bevel
}

enum LineCap: String {
    case butt, round, square
}

extension Fillable where Self : SVGShapeElement {
    
    var fillAttributes: [String : (String) -> ()] {
        return [
            "fill": self.fill,
            "fill-rule": self.fillRule,
            "opacity": self.opacity,
        ]
    }
    
    func fill(fillColor: String) {
        guard let fillColor = UIColor(svgString: fillColor) else {
            return
        }
        self.svgLayer.fillColor = fillColor.cgColor
    }
    
    func fillRule(fillRule: String) {
        guard fillRule == "evenodd" else {
            return
        }
        self.svgLayer.fillRule = kCAFillRuleEvenOdd
    }
    
    func opacity(opacity: String) {
        guard let opacity = CGFloat(opacity) else {
            return
        }
        self.svgLayer.opacity = Float(opacity)
    }
    
}

extension Strokable where Self : SVGShapeElement {
    
    var strokeAttributes: [String : (String) -> ()] {
        return [
            "stroke": self.strokeColor,
            "stroke-linecap": self.strokeLineCap,
            "stroke-linejoin": self.strokeLineJoin,
            "stroke-miterlimit": self.strokeMiterLimit,
            "stroke-width": self.strokeWidth
        ]
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
