//
//  SVGRootElement.swift
//  SwiftSVG
//
//  Created by Michael Choe on 3/5/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

struct SVGRootElement: SVGContainerElement {
    
    static var elementName: String {
        return "svg"
    }
    
    var attributesToApply = [String : String]()
    var containerLayer = CALayer()
    var supportedAttributes = [String : ((String) -> ())?]()
    
    internal func parseWidth(lengthString: String) {
        if let width = Double(lengthString: lengthString) {
            self.containerLayer.frame.size.width = CGFloat(width)
        }
    }
    
    internal func parseHeight(lengthString: String) {
        if let height = Double(lengthString: lengthString) {
            self.containerLayer.frame.size.height = CGFloat(height)
        }
    }
    
    func didProcessElement(in container: SVGContainerElement?) {
        return
    }
    
    func viewBox(coordinates: String) {
        let points = coordinates
            .components(separatedBy: CharacterSet(charactersIn: ", "))
            .flatMap { (thisString) -> Double? in
               return Double(thisString.trimWhitespace())
            }
        guard points.count == 4 else {
            return
        }
        self.containerLayer.frame = CGRect(x: points[0], y: points[1], width: points[2], height: points[3])
        self.containerLayer.masksToBounds = true
    }
}

