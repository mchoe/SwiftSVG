//
//  SVGView.swift
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



#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif





@IBDesignable
open class SVGView : UIView {
    
    var svgLayer = SVGLayer()
    
    @IBInspectable public var SVGName: String? {
        didSet {
            if let thisName = SVGName {
                
                #if !TARGET_INTERFACE_BUILDER
                    let bundle = Bundle.main
                #else
                    let bundle = Bundle(for: type(of: self))
                #endif
                
                /*
                if let url = bundle.url(forResource: thisName, withExtension: "svg") {
                    self.shapeLayer = CAShapeLayer(SVGURL: url)
                    if self.shapeLayer.superlayer == nil {
                        self.nonOptionalLayer.addSublayer(self.shapeLayer)
                    }
                }
                */
            }
        }
    }
}

extension SVGView {
    
    public convenience init(SVGName: String) {
        self.init()
        self.SVGName = SVGName
    }
}

extension SVGView {
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        //print("Laying out subviews")
        
        if let superviewSize = self.superview?.bounds {
            //print("layoutSubviews: \(superviewSize)")
            
            //self.svgLayer.resizeToFit(size: superviewSize)
            //parserToUse.containerLayer.sizeToFit(size: superviewSize)
        }
    }
    
}

