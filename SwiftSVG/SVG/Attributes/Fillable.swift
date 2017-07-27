//
//  Fillable.swift
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
 A protocol that described an instance that can be filled. Two default implementations are provided for this protocol: 
    1. `SVGShapeElement` - Will set the fill color, fill opacity, and fill rule on the underlying `SVGLayer` which is a subclass of `CAShapeLayer`
    2. `SVGGroup` - Will set the fill color, fill opacity, and fill rule of all of a `SVGGroup`'s subelements
 */
public protocol Fillable { }

/**
 Default implementation for fill attributes on `SVGShapeElement`s
 */
extension Fillable where Self : SVGShapeElement {
    
    /**
     The curried functions to be used for the `SVGShapeElement`'s default implementation. This dictionary is meant to be used in the `SVGParserSupportedElements` instance
     - parameter Key: The SVG string value of the attribute
     - parameter Value: A curried function to use to implement the SVG attribute
     */
    var fillAttributes: [String : (String) -> ()] {
        return [
            "color": self.fill,
            "fill": self.fill,
            "fill-opacity": self.fillOpacity,
            "fill-rule": self.fillRule,
            "opacity": self.fillOpacity,
        ]
    }
    
    /**
     Sets the fill color of the underlying `SVGLayer`
     - SeeAlso: CAShapeLayer's [`fillColor`](https://developer.apple.com/documentation/quartzcore/cashapelayer/1522248-fillcolor)
     */
    func fill(fillColor: String) {
        guard let colorComponents = self.svgLayer.fillColor?.components else {
            return
        }
        guard let fillColor = UIColor(svgString: fillColor) else {
            return
        }
        self.svgLayer.fillColor = fillColor.withAlphaComponent(colorComponents[3]).cgColor
    }
    
    /**
     Sets the fill rule of the underlying `SVGLayer`. `CAShapeLayer`s have 2 possible values: `non-zero` (default), and `evenodd`
     - SeeAlso: Core Animation's [Shape Fill Mode Value](https://developer.apple.com/documentation/quartzcore/cashapelayer/shape_fill_mode_values)
     */
    func fillRule(fillRule: String) {
        guard fillRule == "evenodd" else {
            return
        }
        self.svgLayer.fillRule = kCAFillRuleEvenOdd
    }
    
    /**
     Sets the fill opacity of the underlying `SVGLayer` through its CGColor, not the CALayer's opacity property. This value will override any opacity value passed in with the `fill-color` attribute.
     */
    func fillOpacity(opacity: String) {
        guard let opacity = CGFloat(opacity) else {
            return
        }
        guard let colorComponents = self.svgLayer.fillColor?.components else {
            return
        }
        self.svgLayer.fillColor = UIColor(red: colorComponents[0], green: colorComponents[0], blue: colorComponents[0], alpha: opacity).cgColor
    }
    
}


/**
 Default implementation for fill attributes on `SVGGroup`s
 */
extension Fillable where Self : SVGGroup {
    
    ///The curried functions to be used for the `SVGGroup`'s default implementation. This dictionary is meant to be used in the `SVGParserSupportedElements` instance
    var fillAttributes: [String : (String) -> ()] {
        return [
            "color": self.fill,
            "fill": self.fill,
            "fill-opacity": self.fillOpacity,
            "fill-rule": self.fillRule,
            "opacity": self.fillOpacity,
        ]
    }
    
    /**
     Sets the fill color for all subelements of the `SVGGroup`
     */
    func fill(fillColor: String) {
        self.delayedAttributes["fill"] = fillColor
    }
    
    /**
     Sets the fill rule for all subelements of the `SVGGroup`. `CAShapeLayer`s have 2 possible values: `non-zero` (default), and `evenodd`
     - SeeAlso: Core Animation's [Shape Fill Mode Value](https://developer.apple.com/documentation/quartzcore/cashapelayer/shape_fill_mode_values)
     */
    func fillRule(fillRule: String) {
        self.delayedAttributes["fill-rule"] = fillRule
    }
    
    /**
     Sets the fill opacity for all subelements of the `SVGGroup` through its CGColor, not the CALayer's opacity property.
     */
    func fillOpacity(opacity: String) {
        self.delayedAttributes["opacity"] = opacity
    }
    
}

