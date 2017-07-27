//
//  Strokable.swift
//  SwiftSVG
//
//
//  Copyright (c) 2017 Michael Choe
//  http://www.github.com/mchoe
//  http://www.straussmade.com/
//  http://www.twitter.com/_mchoe
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



#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif


/**
 A protocol that described an instance that can be stroked. Two default implementations are provided for this protocol:
    1. `SVGShapeElement` - Will set the underlying `SVGLayer`'s stroke color, width, line cap, line join, and miter limit. Note that `SVGLayer is a subclass of `CAShapeLayer`, so this default implementation wil;l set the `CAShapeLayer`'s line properties and not the `CALayer`'s border attributes.
    2. `SVGGroup` - The default implementation just saves the attributes and values to be applied after all the subelements have been processed.
 */
public protocol Strokable { }

/**
 Line join type that corresponds to the SVG line join string
 */
enum LineJoin: String {
    case miter, round, bevel
}

/**
 Line cap type that corresponds to the SVG line cap string
 */
enum LineCap: String {
    case butt, round, square
}

/**
 Default implementation for stroke attributes on `SVGShapeElement`s
 */
extension Strokable where Self : SVGShapeElement {
    
    /**
     The curried functions to be used for the `SVGShapeElement`'s default implementation. This dictionary is meant to be used in the `SVGParserSupportedElements` instance
     - parameter Key: The SVG string value of the attribute
     - parameter Value: A curried function to use to implement the SVG attribute
     */
    internal var strokeAttributes: [String : (String) -> ()] {
        return [
            "stroke": self.strokeColor,
            "stroke-linecap": self.strokeLineCap,
            "stroke-linejoin": self.strokeLineJoin,
            "stroke-miterlimit": self.strokeMiterLimit,
            "stroke-width": self.strokeWidth
        ]
    }
    
    /**
     Sets the stroke line cap of the underlying `SVGLayer`
     - SeeAlso: CAShapeLayer's [`lineCap`](https://developer.apple.com/documentation/quartzcore/cashapelayer/1521905-linecap) for supported values.
     */
    internal func strokeLineCap(lineCap: String) {
        switch lineCap {
        case kCALineCapButt, kCALineCapRound, kCALineCapSquare:
            self.svgLayer.lineCap = lineCap
        default:
            return
        }
    }
    
    /**
     Sets the stroke color of the underlying `SVGLayer`
     - SeeAlso: CAShapeLayer's [`strokeColor`](https://developer.apple.com/documentation/quartzcore/cashapelayer/1521897-strokecolor)
     */
    internal func strokeColor(strokeColor: String) {
        guard let strokeColor = UIColor(svgString: strokeColor) else {
            return
        }
        self.svgLayer.strokeColor = strokeColor.cgColor
    }
    
    /**
     Sets the stroke line join of the underlying `SVGLayer`
     - SeeAlso: CAShapeLayer's [`lineJoin`](https://developer.apple.com/documentation/quartzcore/cashapelayer/1522147-linejoin)
     */
    internal func strokeLineJoin(lineJoin: String) {
        switch lineJoin {
        case kCALineJoinBevel, kCALineJoinMiter, kCALineJoinRound:
            self.svgLayer.lineJoin = lineJoin
        default:
            return
        }
    }
    
    /**
     Sets the stroke miter limit of the underlying `SVGLayer`
     - SeeAlso: CAShapeLayer's [`miterLimit`](https://developer.apple.com/documentation/quartzcore/cashapelayer/1521870-miterlimit)
     */
    internal func strokeMiterLimit(miterLimit: String) {
        guard let miterLimit = CGFloat(miterLimit) else {
            return
        }
        self.svgLayer.miterLimit = miterLimit
    }
    
    /**
     Sets the stroke width of the underlying `SVGLayer`
     - SeeAlso: CAShapeLayer's [`strokeWidth`](https://developer.apple.com/documentation/quartzcore/cashapelayer/1521890-linewidth)
     */
    internal func strokeWidth(strokeWidth: String) {
        guard let strokeWidth = CGFloat(strokeWidth) else {
            return
        }
        self.svgLayer.lineWidth = strokeWidth
    }
    
}


/**
 Default implementation for fill attributes on `SVGGroup`s
 */
extension Strokable where Self : SVGGroup {
    
    /**
     The curried functions to be used for the `SVGGroup`'s default implementation. This dictionary is meant to be used in the `SVGParserSupportedElements` instance
     - parameter Key: The SVG string value of the attribute
     - parameter Value: A curried function to use to implement the SVG attribute
     */
    var strokeAttributes: [String : (String) -> ()] {
        return [
            "stroke": self.strokeColor,
            "stroke-linecap": self.strokeLineCap,
            "stroke-linejoin": self.strokeLineJoin,
            "stroke-miterlimit": self.strokeMiterLimit,
            "stroke-width": self.strokeWidth
        ]
    }
    
    /**
     Sets the stroke line cap of all subelements
     - SeeAlso: CAShapeLayer's [`lineCap`](https://developer.apple.com/documentation/quartzcore/cashapelayer/1521905-linecap) for supported values.
     */
    internal func strokeLineCap(lineCap: String) {
        self.delayedAttributes["stroke-linecap"] = lineCap
    }
    
    /**
     Sets the stroke color of all subelements
     - SeeAlso: CAShapeLayer's [`strokeColor`](https://developer.apple.com/documentation/quartzcore/cashapelayer/1521897-strokecolor)
     */
    internal func strokeColor(strokeColor: String) {
        self.delayedAttributes["stroke"] = strokeColor
    }
    
    /**
     Sets the stroke line join of all subelements
     - SeeAlso: CAShapeLayer's [`lineJoin`](https://developer.apple.com/documentation/quartzcore/cashapelayer/1522147-linejoin)
     */
    internal func strokeLineJoin(lineJoin: String) {
        self.delayedAttributes["stroke-linejoin"] = lineJoin
    }
    
    /**
     Sets the stroke miter limit of all subelements
     - SeeAlso: CAShapeLayer's [`miterLimit`](https://developer.apple.com/documentation/quartzcore/cashapelayer/1521870-miterlimit)
     */
    internal func strokeMiterLimit(miterLimit: String) {
        self.delayedAttributes["stroke-miterlimit"] = miterLimit
    }
    
    /**
     Sets the stroke width of all subelements
     - SeeAlso: CAShapeLayer's [`strokeWidth`](https://developer.apple.com/documentation/quartzcore/cashapelayer/1521890-linewidth)
     */
    internal func strokeWidth(strokeWidth: String) {
        self.delayedAttributes["stroke-width"] = strokeWidth
    }
    
}
