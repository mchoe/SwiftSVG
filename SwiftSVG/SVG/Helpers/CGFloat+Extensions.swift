//
//  CGFloat+Extensions.swift
//  SwiftSVGiOS
//
//  Created by Michael Choe on 6/6/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import CoreGraphics

extension CGFloat {
    
    init?(_ string: String) {
        guard let asDouble = Double(string) else {
            return nil
        }
        self.init(asDouble)
    }
    
    init?(byteArray: [CChar], base: Int32 = 10) {
        guard byteArray.last == 0 else {
            var nullTerminated = byteArray
            nullTerminated.append(0)
            self.init(strtol(nullTerminated, nil, base))
            return
        }
        self.init(strtol(byteArray, nil, base))
    }
    
}

extension Float {
    
    init?(byteArray: [CChar]) {
        guard byteArray.last == 0 else {
            var nullTerminated = byteArray
            nullTerminated.append(0)
            self = strtof(nullTerminated, nil)
            return
        }
        self = strtof(byteArray, nil)
    }
    
}

extension Double {
    
    /*
    init?(byteArray: [CChar]) {
        guard byteArray.last == 0 else {
            var nullTerminated = byteArray
            nullTerminated.append(0)
            self = strtod(nullTerminated, nil)
            return
        }
        self = strtod(byteArray, nil)
    }
    */
    
    init?(byteArray: [CChar]) {
        var nullTerminated = byteArray
        nullTerminated.append(0)
        self = strtod(nullTerminated, nil)
    }
}
