//
//  SVGRectangle.swift
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
 Concrete implementation that creates a `CAShapeLayer` from a `<rect>` element and its attributes
 */

final class SVGRectangle: SVGShapeElement {
    
    /// :nodoc:
    internal static let elementName = "rect"
    
    /**
     The CGRect for the rectangle
     */
    internal var rectangleRect = CGRect()
    
    /// :nodoc:
    internal var svgLayer = CAShapeLayer()
    
    /// :nodoc:
    internal var supportedAttributes: [String : (String) -> ()] = [:]
    
    /**
     The x radius of the corner oval. Defaults to `0`
     */
    internal var xCornerRadius = CGFloat(0.0)
    
    /**
     The y radius of the corner oval. Defaults to `0`
     */
    internal var yCornerRadius = CGFloat(0.0)
    
    /**
     Function that parses the number string and sets this rectangle's origin x
     */
    internal func parseX(x: String) {
        guard let x = CGFloat(x) else {
            return
        }
        self.rectangleRect.origin.x = x
    }
    
    /**
     Function that parses the number string and sets this rectangle's origin y
     */
    internal func parseY(y: String) {
        guard let y = CGFloat(y) else {
            return
        }
        self.rectangleRect.origin.y = y
    }
    
    /**
     Function that parses the number string and sets this rectangle's height
     */
    internal func rectangleHeight(height: String) {
        guard let height = CGFloat(height) else {
            return
        }
        self.rectangleRect.size.height = height
    }
    
    /**
     Function that parses the number string and sets this rectangle's width
     */
    internal func rectangleWidth(width: String) {
        guard let width = CGFloat(width) else {
            return
        }
        self.rectangleRect.size.width = width
    }
    
    /**
     Function that parses the number string and sets this rectangle's x corner radius
     */
    internal func xCornerRadius(xCornerRadius: String) {
        guard let xCornerRadius = CGFloat(xCornerRadius) else {
            return
        }
        self.xCornerRadius = xCornerRadius
    }
    
    /**
     Function that parses the number string and sets this rectangle's y corner radius
     */
    internal func yCornerRadius(yCornerRadius: String) {
        guard let yCornerRadius = CGFloat(yCornerRadius) else {
            return
        }
        self.yCornerRadius = yCornerRadius
    }
    
    /**
     Creates a new rectangle path based on the set attributes.
     */
    internal func didProcessElement(in container: SVGContainerElement?) {
        guard let container = container else {
            return
        }
        
        // TODO: There seems to be a bug with UIBezierPath(roundedRect:byRoundingCorners:cornerRadii:)
        // where it will draw an unclosed path if the corner radius is zero, so to get around this
        // you have to check which initializer to use.
        //
        // Also at some point, will have to convert this to use 2 layers because this implementation
        // only rounds the outer border and leaves the inner corners pointed.
        //
        // -Michael Choe 06.28.17
        
        let rectanglePath: UIBezierPath
        if (self.xCornerRadius > 0 || self.yCornerRadius > 0) {
            #if os(iOS) || os(tvOS)
            rectanglePath = UIBezierPath(roundedRect: self.rectangleRect, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: self.xCornerRadius, height: self.yCornerRadius))
            #elseif os(OSX)
            // TODO:
            // Should create an extension that duplicates the UIBezierPath initializer
            rectanglePath = NSBezierPath(roundedRect: self.rectangleRect, xRadius: self.xCornerRadius, yRadius: self.yCornerRadius)
            #endif
            
        } else {
            rectanglePath = UIBezierPath(rect: self.rectangleRect)
        }
        self.svgLayer.path = rectanglePath.cgPath
        container.containerLayer.addSublayer(self.svgLayer)
    }
}
