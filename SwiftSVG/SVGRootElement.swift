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
    import QuartzCore
#endif

struct SVGRootElement: SVGElement {
    var supportedAttributes = [String : (String) -> ()]()
    var svgLayer = CALayer()
}

