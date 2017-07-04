//
//  SVGLayer.swift
//  SwiftSVG
//
//  Created by tarragon on 7/1/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

public protocol SVGLayerType {
    var boundingBox: CGRect { get }
}

open class SVGLayer: CALayer, SVGLayerType {
    
    public var boundingBox = CGRect.zero
    
    /*
    public convenience init(SVGURL: URL, parser: SVGParser? = nil, completion: ((SVGLayer) -> Void)? = nil) {
        self.init()
        _ = SVGParser(SVGURL: SVGURL, containerLayer: self, completion: completion)
    }
    */
}

extension SVGLayerType where Self: CALayer {
    
    public func resizeToFit(size: CGRect) {
        
        DispatchQueue.main.safeAsync {
            
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
            let translate = CGAffineTransform(translationX: -self.boundingBox.origin.x, y: -self.boundingBox.origin.y)
            let concat = translate.concatenating(scaleTransform)
            
            self.setAffineTransform(scaleTransform)
            
        }
    }
    
}


