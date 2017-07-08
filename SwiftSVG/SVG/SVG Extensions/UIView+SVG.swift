//
//  UIView+SVG.swift
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



import Foundation
#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

extension UIView {
    
    public convenience init(pathString: String) {
        self.init()
        let svgLayer = SVGLayer()
        let pathPath = UIBezierPath(pathString: pathString)
        svgLayer.path = pathPath.cgPath
        self.layer.addSublayer(svgLayer)
    }
    
    public convenience init(SVGURL: URL, parser: SVGParser? = nil, completion: ((SVGLayer) -> Void)? = nil) {
        self.init()
        
        _ = CALayer(SVGURL: SVGURL, parser: parser) { (svgLayer) in
            
            if let superviewSize = self.superview?.bounds {
                svgLayer.resizeToFit(size: superviewSize)
            }
            DispatchQueue.main.safeAsync {
                self.nonOptionalLayer.addSublayer(svgLayer)
            }
            completion?(svgLayer)
        }
    }
	
    
	public convenience init(SVGData: Data, parser: SVGParser? = nil, completion: ((SVGLayer) -> Void)? = nil) {
		self.init()
        
        _ = CALayer(SVGData: SVGData, parser: parser) { (svgLayer) in
            
            if let superviewSize = self.superview?.bounds {
                svgLayer.resizeToFit(size: superviewSize)
            }
            DispatchQueue.main.safeAsync {
                self.nonOptionalLayer.addSublayer(svgLayer)
            }
            completion?(svgLayer)
        }
	}
    
}
