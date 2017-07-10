//
//  CrossPlatform.swift
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

#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit
#elseif os(OSX)
    import AppKit
    public typealias UIView = NSView
    public typealias UIBezierPath = NSBezierPath
    public typealias UIColor = NSColor
#endif

extension UIView {
    var nonOptionalLayer:CALayer {
        #if os(iOS) || os(tvOS) || os(watchOS)
            return self.layer
        #elseif os(OSX)
            if let l = self.layer {
                return l
            } else {
                self.layer = CALayer()
                self.layer?.frame = self.bounds
                let flip = CATransform3DMakeScale(1.0, -1.0, 1.0)
                let translate = CATransform3DMakeTranslation(0.0, self.bounds.size.height, 1.0)
                self.layer?.sublayerTransform = CATransform3DConcat(flip, translate)
                self.wantsLayer = true
                return self.layer!
            }
        #endif
    }
}
