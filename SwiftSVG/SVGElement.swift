//
//  SVGElement.swift
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

// NOTE: For the supported attributes, I wanted to use a little currying
// magic so that it could potentially take any method on any arbitrary 
// type. The type signature would look like this `[String : (Self) -> (String) -> ()]`
// 
// Unfortunately, I couldn't get this to work because the curried type wouldn't be known
// at runtime. I think if and when Swift adopts language level type erasure, then
// this will be possible. I'm flagging this here to keep that in mind because
// I think that will yield a cleaner design and implementation.
//
// -Michael Choe 06.03.17

protocol SVGElement {
    var supportedAttributes: [String : (String) -> ()] { get set }
    var svgLayer: CALayer { get set }
}
