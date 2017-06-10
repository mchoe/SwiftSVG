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
    var workingString: String.UnicodeScalarView
    //let separator: Character = " "
    var stringIndex: Int = 0
    
    var scalarIndex: String.UnicodeScalarView.Index
    
    init(coordinateString: String) {
        self.coordinateString = coordinateString
        self.workingString = self.coordinateString.unicodeScalars
        self.scalarIndex = self.workingString.startIndex
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
        
        //var xNumberArray = [Character]()
        //var yNumberArray = [Character]()
        var xNumber = String.UnicodeScalarView()
        var yNumber = String.UnicodeScalarView()
        var didParseX = false
        
        //var thisCharacter = self.coordinateString[self.stringIndex]
        var thisCharacter = self.workingString[self.scalarIndex]
        //while thisCharacter != self.separator {
        while thisCharacter != " " {
            if thisCharacter == "," {
                didParseX = true
            } else {
                if !didParseX {
                    //xNumberArray.append(thisCharacter)
                    xNumber.append(thisCharacter)
                } else {
                    //yNumberArray.append(thisCharacter)
                    yNumber.append(thisCharacter)
                }
            }
            //self.stringIndex += 1
            self.scalarIndex = self.workingString.index(after: self.scalarIndex)
            if self.stringIndex < characterCount {
                //thisCharacter = self.coordinateString[self.stringIndex]
                thisCharacter = self.workingString[self.scalarIndex]
            } else {
                break
            }
        }
        
        if let xAsDouble = Double(String(xNumber)), let yAsDouble = Double(String(yNumber)) {
            guard self.stringIndex <= characterCount else {
                return nil
            }
            self.stringIndex += 1
            return CGPoint(x: xAsDouble, y: yAsDouble)
        }
        return nil
    }
}



