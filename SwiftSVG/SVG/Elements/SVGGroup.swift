//
//  SVGGroup.swift
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

struct SVGGroup: SVGContainerElement {
    
    var containerLayer = CALayer()
    var supportedAttributes = [String : (String) -> ()]()
    
    func didProcessElement(in container: SVGContainerElement?) {
        print("Did process SVG Element: \(self.containerLayer.frame)")
    }
    
}
