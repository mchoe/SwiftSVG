//
//  FloatingPoint+DegreesRadians.swift
//  SwiftSVG
//
//  Created by tarragon on 6/25/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import Foundation

extension FloatingPoint {
    
    var toRadians: Self {
        return self * .pi / 180
    }
    
    var toDegrees: Self {
        return self * 180 / .pi
    }
}
