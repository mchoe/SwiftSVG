//
//  Scalar+FromByteArray.swift
//  SwiftSVGiOS
//
//
//  Copyright (c) 2017 Michael Choe
//  http://www.github.com/mchoe
//  http://www.straussmade.com/
//  http://www.twitter.com/_mchoe
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.



import CoreGraphics



extension CGFloat {
    
    /**
     Initializer that creates a new CGFloat from a String
     */
    internal init?(_ string: String) {
        guard let asDouble = Double(string) else {
            return nil
        }
        self.init(asDouble)
    }
    
    /**
     Initializer that creates a new CGFloat from a Character byte array with the option to set the base.
     */
    internal init?(byteArray: [CChar], base: Int32 = 10) {
        var nullTerminated = byteArray
        nullTerminated.append(0)
        self.init(strtol(nullTerminated, nil, base))
    }
    
}
 

extension Float {
    
    /**
     Initializer that creates a new Float from a Character byte array
     */
    internal init?(byteArray: [CChar]) {
        
        guard byteArray.count > 0 else {
            return nil
        }
        var nullTerminated = byteArray
        nullTerminated.append(0)
        var error: UnsafeMutablePointer<Int8>? = nil
        let result = strtof(nullTerminated, &error)
        if error != nil && error?.pointee != 0 {
            return nil
        }
        self = result
    }
    
}

extension Double {
    
    /**
     Initializer that creates a new Double from a Character byte array
     */
    internal init?(byteArray: [CChar]) {
        
        guard byteArray.count > 0 else {
            return nil
        }
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
