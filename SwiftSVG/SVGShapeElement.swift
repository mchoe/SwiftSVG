//
//  SVGShapeElement.swift
//  SwiftSVG
//
//  Created by Michael Choe on 6/4/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

protocol SVGShapeElement: SVGElement {
    var svgLayer: CAShapeLayer { get set }
}

extension SVGShapeElement {
    
    internal func fillHex(attributeString: String) {
        self.svgLayer.fillColor = UIColor(hexString: attributeString).cgColor
    }
    
    internal func strokeColor(strokeColor: String) {
        self.svgLayer.strokeColor = UIColor(hexString: strokeColor).cgColor
    }
    
    internal func strokeWidth(strokeWidth: String) {
        guard let strokeWidth = Double(lengthString: strokeWidth) else {
            return
        }
        self.svgLayer.lineWidth = CGFloat(strokeWidth)
    }
    
}
