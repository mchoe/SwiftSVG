//
//  SVGPolyline.swift
//  SwiftSVG
//
//  Created by Michael Choe on 6/5/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

struct SVGPolyline: SVGShapeElement {
    
    var svgLayer = CAShapeLayer()
    var supportedAttributes: [String : (String) -> ()] = [:]
    
    func points(points: String) {
        
    }
    
    func didProcessElement(in container: SVGContainerElement?) {
        
    }
}
