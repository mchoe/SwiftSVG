//
//  SVGPolygon.swift
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

struct SVGPolygon: SVGShapeElement {
    
    var svgLayer = CAShapeLayer()
    var supportedAttributes: [String : (String) -> ()] = [:]
    
    internal func points(points: String) {
        let polylinePath = UIBezierPath()
        for (index, thisPoint) in CoordinateLexer(coordinateString: points).enumerated() {
            if index == 0 {
                polylinePath.move(to: thisPoint)
            } else {
                polylinePath.addLine(to: thisPoint)
            }
            print("Point [\(index)]: \(thisPoint)")
        }
        polylinePath.close()
        print("Path: \(polylinePath)")
        self.svgLayer.path = polylinePath.cgPath
    }
    
    func didProcessElement(in container: SVGContainerElement?) {
        guard let container = container else {
            return
        }
        container.containerLayer.addSublayer(self.svgLayer)
        //print("Layer: \(self.svgLayer.frame)")
    }
}
