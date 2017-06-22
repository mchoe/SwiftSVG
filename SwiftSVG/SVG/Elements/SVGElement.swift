//
//  SVGElement.swift
//  SwiftSVG
//
//  Created by Michael Choe on 3/5/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

// TODO:
// NOTE: For the supported attributes, I wanted to use a little currying
// magic so that it could potentially take any method on any arbitrary 
// type. The type signature would look like this `[String : (Self) -> (String) -> ()]`
// 
// Unfortunately, I couldn't get this to work because the curried type wouldn't be known
// at runtime. Understandable, and my first inclination was to use type erasure to no avail. 
// I think if and when Swift adopts language level type erasure, then
// this will be possible. I'm flagging this here to keep that in mind because
// I think that will yield a cleaner design and implementation.
//
// -Michael Choe 06.03.17


protocol SVGElement {
    var supportedAttributes: [String : ((String) -> ())?] { get set }
    
    func didProcessElement(in container: SVGContainerElement?)
}

protocol SVGContainerElement: SVGElement {
    var containerLayer: CALayer { get set }
    var attributesToApply: [String : String] { get set }
}

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
            "fill": self.fillHex,
            "fill-rule": self.fillRule,
            "opacity": self.opacity,
        ]
    }
    
    
    
    func fillHex(fillColor: String) {
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


