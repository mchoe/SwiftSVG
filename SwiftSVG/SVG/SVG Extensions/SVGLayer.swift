//
//  SVGLayer.swift
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


public protocol SVGLayerType {
    var boundingBox: CGRect { get }
}

/**
 A `CAShapeLayer` subclass that allows you to easily work with sublayers and get sizing information
 */

open class SVGLayer: CAShapeLayer, SVGLayerType {
    
    /// The minimum CGRect that fits all subpaths
    public var boundingBox = CGRect.zero
}

extension SVGLayerType where Self: CALayer {
    
    /**
     Scales a layer to aspect fit the given size.
     */
    
    @discardableResult
    public func resizeToFit(_ size: CGRect) -> Self {
        
        let containingSize = size
        let boundingBoxAspectRatio = self.boundingBox.width / self.boundingBox.height
        let viewAspectRatio = containingSize.width / containingSize.height
        
        let scaleFactor: CGFloat
        if (boundingBoxAspectRatio > viewAspectRatio) {
            // Width is limiting factor
            scaleFactor = containingSize.width / self.boundingBox.width
        } else {
            // Height is limiting factor
            scaleFactor = containingSize.height / self.boundingBox.height
        }
        
        let scaleTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        
        DispatchQueue.main.safeAsync {
            self.setAffineTransform(scaleTransform)
        }
        return self
    }
}

extension CALayer {
    
    open func applyOnSublayers<T: CALayer>(ofType: T.Type, closure: (T) -> ()) {
        let allShapelayers: [T] = self.sublayers(in: self)
        _ = allShapelayers.map { (thisShapeLayer) -> T in
            closure(thisShapeLayer)
            return thisShapeLayer
        }
    }
    
    open func sublayers<T: CALayer, U>(in layer: T) -> [U] {
        
        var sublayers = [U]()
        
        guard let allSublayers = layer.sublayers else {
            return sublayers
        }
        
        for thisSublayer in allSublayers {
            sublayers += self.sublayers(in: thisSublayer)
            if let thisSublayer = thisSublayer as? U {
                sublayers.append(thisSublayer)
            }
        }
        return sublayers
    }
}

// MARK: - Fill Overrides

extension SVGLayer {
    
    /// Applies the given fill color to all sublayers
    override open var fillColor: CGColor? {
        didSet {
            self.applyOnSublayers(ofType: CAShapeLayer.self) { (thisShapeLayer) in
                thisShapeLayer.fillColor = fillColor
            }
        }
    }
}

// MARK: - Storke Overrides

extension SVGLayer {
    
    /// Applies the given line width to all `CAShapeLayer`s
    override open var lineWidth: CGFloat {
        didSet {
            self.applyOnSublayers(ofType: CAShapeLayer.self) { (thisShapeLayer) in
                thisShapeLayer.lineWidth = lineWidth
            }
        }
    }
    
    /// Applies the given stroke color to all `CAShapeLayer`s
    override open var strokeColor: CGColor? {
        didSet {
            self.applyOnSublayers(ofType: CAShapeLayer.self) { (thisShapeLayer) in
                thisShapeLayer.strokeColor = fillColor
            }
        }
    }
}

