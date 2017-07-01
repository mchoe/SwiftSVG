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

protocol SVGLayerType {
    var boundingBox: CGRect { get }
}

open class SVGLayer: CALayer, SVGLayerType {
    
    var boundingBox = CGRect.zero
    
    public convenience init(SVGURL: URL) {
        self.init()
        _ = SVGParser(SVGURL: SVGURL, containerLayer: self)
    }
    
}

extension SVGLayerType where Self: CALayer {
    
    func sizeToFit(size: CGRect) {
        
        DispatchQueue.main.safeAsync {
            
            let boundingBoxLayer = CAShapeLayer()
            boundingBoxLayer.path = UIBezierPath(rect: self.boundingBox).cgPath
            boundingBoxLayer.fillColor = UIColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 0.35).cgColor
            
            //self.containerLayer?.addSublayer(boundingBoxLayer)
            
            print("Bounding Box: \(self.boundingBox)")
            
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


