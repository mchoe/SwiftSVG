//
//  CoordinateIterator.swift
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



import CoreGraphics
import Foundation

/**
 A struct that conforms to the `Sequence` protocol that takes a coordinate string and continuously returns`CGPoint`s
 */
internal struct CoordinateLexer: IteratorProtocol, Sequence {
    
    /**
     Generates a `CGPoint`
     */
    typealias Element = CGPoint
    
    /// :nodoc:
    private var currentCharacter: CChar {
        return self.workingString[self.interatorIndex]
    }
    
    /// :nodoc:
    private var coordinateString: String
    
    /// :nodoc:
    private var workingString: ContiguousArray<CChar>
    
    /// :nodoc:
    private var interatorIndex: Int = 0
    
    /// :nodoc:
    private var numberArray = [CChar]()
    
    /**
     Creates a new `CoordinateLexer` from a comma or space separated number string
     */
    internal init(coordinateString: String) {
        self.coordinateString = coordinateString.trimWhitespace()
        self.workingString = self.coordinateString.utf8CString
    }
    
    /**
     Required by Swift's `IteratorProtocol` that returns a new `CoordinateLexer`
     */
    internal func makeIterator() -> CoordinateLexer {
        return CoordinateLexer(coordinateString: self.coordinateString)
    }
    
    /**
     Required by Swift's `IteratorProtocol` that returns the next `CGPoint` or nil if it's at the end of the sequence
     */
    internal mutating func next() -> Element? {
        
        var didParseX = false
        var returnPoint = CGPoint.zero
        
        while self.interatorIndex < self.workingString.count - 1 {
            
            switch self.currentCharacter {
            case PathDConstants.DCharacter.comma.rawValue, PathDConstants.DCharacter.space.rawValue:
                self.interatorIndex += 1
                if !didParseX {
                    if let asDouble = Double(byteArray: self.numberArray) {
                        returnPoint.x = CGFloat(asDouble)
                        self.numberArray.removeAll()
                        didParseX = true
                    }
                } else {
                    if let asDouble = Double(byteArray: self.numberArray) {
                        returnPoint.y = CGFloat(asDouble)
                        self.numberArray.removeAll()
                        didParseX = false
                        return returnPoint
                    }
                }
                
            default:
                self.numberArray.append(self.currentCharacter)
                self.interatorIndex += 1
            }
        }
        if didParseX {
            if let asDouble = Double(byteArray: self.numberArray) {
                returnPoint.y = CGFloat(asDouble)
                self.numberArray.removeAll()
                return returnPoint
            }
        }
        return nil
    }
}



