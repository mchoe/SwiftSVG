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

protocol SVGShapeElement: SVGElement, Fillable, Strokable, Transformable, Stylable {
    var svgLayer: CAShapeLayer { get set }
}

