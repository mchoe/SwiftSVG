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

/**
 A protocol that describes an instance that can store bounding box information
 */
public protocol SVGLayerType {
    var boundingBox: CGRect { get }
}

public extension SVGLayerType where Self: CALayer {

    /**
     Scales a layer to aspect fit the given size.
     - Parameter rect: The `CGRect` to fit into
     - TODO: Should eventually support different content modes
     */
    @discardableResult
    public func resizeToFit(_ rect: CGRect) -> Self {
        
        let boundingBoxAspectRatio = self.boundingBox.width / self.boundingBox.height
        let viewAspectRatio = rect.width / rect.height
        
        let scaleFactor: CGFloat
        if (boundingBoxAspectRatio > viewAspectRatio) {
            // Width is limiting factor
            scaleFactor = rect.width / self.boundingBox.width
        } else {
            // Height is limiting factor
            scaleFactor = rect.height / self.boundingBox.height
        }
        let scaleTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        
        DispatchQueue.main.safeAsync {
            self.setAffineTransform(scaleTransform)
        }
        return self
    }
}

/**
 A `CAShapeLayer` subclass that allows you to easily work with sublayers and get sizing information
 */

open class SVGLayer: CAShapeLayer, SVGLayerType {
    
    /// The minimum CGRect that fits all subpaths
    public var boundingBox = CGRect.zero
}

public extension SVGLayer {
    
    /**
     Returns a copy of the given SVGLayer
     */
    public var svgLayerCopy: SVGLayer? {
        let tmp = NSKeyedArchiver.archivedData(withRootObject: self)
        let copiedLayer = NSKeyedUnarchiver.unarchiveObject(with: tmp) as? SVGLayer
        copiedLayer?.boundingBox = self.boundingBox
        return copiedLayer
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

// MARK: - Stroke Overrides

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

