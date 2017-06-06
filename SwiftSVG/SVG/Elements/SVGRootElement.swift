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
    
    var containerLayer = CALayer()
    var supportedAttributes = [String : (String) -> ()]()
    
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
        print("Did process SVG Element: \(self.containerLayer.frame)")
    }
}

