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
    let separator: Character = " "
    var stringIndex: Int = 0
    
    init(coordinateString: String) {
        self.coordinateString = coordinateString
        if self.coordinateString[self.stringIndex] == " " || self.coordinateString[self.coordinateString.characters.count - 1] == " " {
            self.coordinateString = self.coordinateString.trimWhitespace()
        }
    }
    
    func makeIterator() -> CoordinateLexer {
        return CoordinateLexer(coordinateString: self.coordinateString)
    }
    
    mutating func next() -> Element? {
        
        let characterCount = self.coordinateString.characters.count
        
        guard self.stringIndex + 1 < characterCount else {
            return nil
        }
        
        var xNumberArray = [Character]()
        var yNumberArray = [Character]()
        var didParseX = false
        
        var thisCharacter = self.coordinateString[self.stringIndex]
        while thisCharacter != self.separator {
            if thisCharacter == "," {
                didParseX = true
            } else {
                if !didParseX {
                    xNumberArray.append(thisCharacter)
                } else {
                    yNumberArray.append(thisCharacter)
                }
            }
            self.stringIndex += 1
            if self.stringIndex < characterCount {
                thisCharacter = self.coordinateString[self.stringIndex]
            } else {
                break
            }
        }
        
        if let xAsDouble = Double(String(xNumberArray)), let yAsDouble = Double(String(yNumberArray)) {
            guard self.stringIndex <= characterCount else {
                return nil
            }
            self.stringIndex += 1
            return CGPoint(x: xAsDouble, y: yAsDouble)
        }
        return nil
    }
}



