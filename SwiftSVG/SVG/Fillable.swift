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



#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif



protocol Fillable { }

extension Fillable where Self : SVGShapeElement {
    
    var fillAttributes: [String : (String) -> ()] {
        return [
            "color": self.fill,
            "fill": self.fill,
            "fill-opacity": self.opacity,
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

extension Fillable where Self : SVGGroup {
    
    var fillAttributes: [String : (String) -> ()] {
        return [
            "color": self.fill,
            "fill": self.fill,
            "fill-opacity": self.opacity,
            "fill-rule": self.fillRule,
            "opacity": self.opacity,
        ]
    }
    
    func fill(fillColor: String) {
        self.attributesToApply["fill"] = fillColor
    }
    
    func fillRule(fillRule: String) {
        self.attributesToApply["fill-rule"] = fillRule
    }
    
    func opacity(opacity: String) {
        self.attributesToApply["opacity"] = opacity
    }
    
}

