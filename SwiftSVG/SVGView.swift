//
//  SVGView.swift
//  SwiftSVG
//
//  Copyright (c) 2015 Michael Choe
//  http://www.straussmade.com/
//  http://www.twitter.com/_mchoe
//  http://www.github.com/mchoe
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

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif


@IBDesignable
public class SVGView : UIView {
    
    var shapeLayer = CAShapeLayer()
    
    @IBInspectable public var SVGName: String? {
        didSet {
            if let thisName = SVGName {
                
                #if !TARGET_INTERFACE_BUILDER
                    let bundle = NSBundle.mainBundle()
                #else
                    let bundle = NSBundle(forClass: self.dynamicType)
                #endif
                
                SVGURL = bundle.URLForResource(thisName, withExtension: "svg")
            }
        }
    }
    
    public var SVGURL: NSURL? {
        didSet {
            guard let url = SVGURL else {
                shapeLayer.removeFromSuperlayer()
                return
            }
            
            shapeLayer = CAShapeLayer(SVGURL: url)
            self.nonOptionalLayer.addSublayer(self.shapeLayer)
        }
    }
    
}

extension SVGView {
    public convenience init(SVGName: String) {
        self.init()
        self.SVGName = SVGName
    }
    
    public convenience init(SVGURL: NSURL) {
        self.init()
        self.SVGURL = SVGURL
    }
}
