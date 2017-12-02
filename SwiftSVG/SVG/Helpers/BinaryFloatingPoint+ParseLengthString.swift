//
//  FloatingPoint+ParseLengthString.swift
//  SwiftSVG
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



import Foundation

/**
 Extension that takes a length string, e.g. `100px`, `20mm` and parses it into a `BinaryFloatingPoint` (e.g. `Float`, `Double`, `CGFloat`)
 */
extension BinaryFloatingPoint {
    
    /**
     Parses a number string with optional suffix, such as `px`, `mm`
     */
    internal init?(lengthString: String) {
        
        let simpleNumberClosure: (String) -> Double? = { (string) -> Double? in
            return Double(string)
        }
        
        if let thisNumber = simpleNumberClosure(lengthString) {
            self.init(thisNumber)
            return
        }
        
        let numberFromSupportedSuffix: (String, String) -> Double? = { (string, suffix) -> Double? in
            if string.hasSuffix(suffix) {
                return simpleNumberClosure(string[0..<string.count - suffix.count])
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
