//
//  FloatingPoint+ParseLengthString.swift
//  SwiftSVG
//
//  Created by Michael Choe on 6/4/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import Foundation

// TODO
// NOTE: The better protocol here would be BinaryFloatingPoint, but for some
// reason, the compiler is unable to find the overload when trying to use it,
// so I have to extend FloatingPoint instead and then typecast it at run time
//
// - Michael Choe 06.04.17

extension BinaryFloatingPoint {
    
    init?(lengthString: String) {
        
        let simpleNumberClosure: (String) -> Double? = { (string) -> Double? in
            return Double(string)
        }
        
        if let thisNumber = simpleNumberClosure(lengthString) {
            self.init(thisNumber)
            return
        }
        
        let numberFromSupportedSuffix: (String, String) -> Double? = { (string, suffix) -> Double? in
            if string.hasSuffix(suffix) {
                let index = string.index(string.endIndex, offsetBy: -(suffix.characters.count))
                return simpleNumberClosure(string.substring(to: index))
            }
            return nil
        }
        
        if let withPxAnnotation = numberFromSupportedSuffix(lengthString, "px") {
            self.init(withPxAnnotation)
            return
        }
        
        if let withMmAnnotation = numberFromSupportedSuffix(lengthString, "mm") {
            self.init(withMmAnnotation)
            return
        }
        
        return nil
    }
    
}
