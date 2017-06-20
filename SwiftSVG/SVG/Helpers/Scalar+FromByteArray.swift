//
//  Scalar+FromByteArray.swift
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
        var nullTerminated = byteArray
        nullTerminated.append(0)
        self.init(strtol(nullTerminated, nil, base))
    }
    
}

extension Float {
    
    init?(byteArray: [CChar]) {
        var nullTerminated = byteArray
        nullTerminated.append(0)
        self = strtof(nullTerminated, nil)
    }
    
}

extension Double {
    
    init?(byteArray: [CChar]) {
        
        if byteArray.count == 0 {
            return nil
        }
        
        //var nullTerminated = byteArray
        //nullTerminated.append(0)
        //self = strtod(nullTerminated, nil)
        
        
        var nullTerminated = byteArray
        nullTerminated.append(0)
        var error: UnsafeMutablePointer<Int8>? = nil
        let result = strtod(nullTerminated, &error)
        if error != nil && error?.pointee != 0 {
            return nil
        }
        self = result
        
        
    }
}
