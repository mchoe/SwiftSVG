//
//  CoordinateIterator.swift
//  SwiftSVG
//
//  Created by Michael Choe on 6/5/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import CoreGraphics
import Foundation

struct CoordinateLexer: IteratorProtocol, Sequence {
    typealias Element = CGPoint
    var coordinateString: String
    var workingString: ContiguousArray<CChar>
    var stringIndex: Int = 0
    
    init(coordinateString: String) {
        self.coordinateString = coordinateString
        self.workingString = self.coordinateString.utf8CString
    }
    
    func makeIterator() -> CoordinateLexer {
        return CoordinateLexer(coordinateString: self.coordinateString)
    }
    
    mutating func next() -> Element? {
        
        let characterCount = self.coordinateString.characters.count
        
        guard self.stringIndex + 1 < characterCount else {
            return nil
        }
        
        var xNumber = [CChar]()
        var yNumber = [CChar]()
        var didParseX = false
        
        var thisCharacter = self.workingString[self.stringIndex]
        while thisCharacter != 32 { // SPACE separator
            if thisCharacter == 44 { // comma
                didParseX = true
            } else {
                if !didParseX {
                    xNumber.append(thisCharacter)
                } else {
                    yNumber.append(thisCharacter)
                }
            }
            self.stringIndex += 1
            if self.stringIndex < characterCount {
                thisCharacter = self.workingString[self.stringIndex]
            } else {
                break
            }
        }
        
        if let xAsDouble = Double(byteArray: xNumber), let yAsDouble = Double(byteArray: yNumber) {
            guard self.stringIndex <= characterCount else {
                return nil
            }
            self.stringIndex += 1
            return CGPoint(x: xAsDouble, y: yAsDouble)
        }
        return nil
    }
}



