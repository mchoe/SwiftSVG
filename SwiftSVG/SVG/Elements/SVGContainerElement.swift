//
//  SVGContainerElement.swift
//  SwiftSVG
//
//  Created by tarragon on 6/28/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

protocol SVGContainerElement: SVGElement, Fillable, Strokable, Transformable, Stylable {
    var containerLayer: CALayer { get set }
    var attributesToApply: [String : String] { get set }
}
