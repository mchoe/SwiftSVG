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
    var xNumber = [CChar]()
    var yNumber = [CChar]()
    
    init(coordinateString: String) {
        self.coordinateString = coordinateString.trimWhitespace()
        self.workingString = self.coordinateString.utf8CString
    }
    
    func makeIterator() -> CoordinateLexer {
        return CoordinateLexer(coordinateString: self.coordinateString)
    }
    
    mutating func next() -> Element? {
        
        let characterCount = self.workingString.count - 1
        
        guard self.stringIndex + 1 < characterCount else {
            return nil
        }
        
        self.xNumber.removeAll()
        self.yNumber.removeAll()
        
        var numberParsed = 0
        
        var thisCharacter = self.workingString[self.stringIndex]
        while self.stringIndex < characterCount { // SPACE or COMMA separator
            
            if (thisCharacter == 32 || thisCharacter == 44) {
                if numberParsed == 0 {
                    numberParsed += 1
                    self.stringIndex += 1
                    thisCharacter = self.workingString[self.stringIndex]
                } else {
                    break
                }
            }
            
            if numberParsed == 0 {
                self.xNumber.append(thisCharacter)
            } else {
                self.yNumber.append(thisCharacter)
            }
            
            self.stringIndex += 1
            thisCharacter = self.workingString[self.stringIndex]
        }
        
        if let xAsDouble = Double(byteArray: self.xNumber), let yAsDouble = Double(byteArray: self.yNumber) {
            guard self.stringIndex <= characterCount else {
                return nil
            }
            self.stringIndex += 1
            return CGPoint(x: xAsDouble, y: yAsDouble)
        }
        return nil
    }
}



