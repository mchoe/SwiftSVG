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
    
    var currentCharacter: CChar {
        return self.workingString[self.interatorIndex]
    }
    var coordinateString: String
    var workingString: ContiguousArray<CChar>
    var interatorIndex: Int = 0
    var numberArray = [CChar]()
    //var yNumber = [CChar]()
    
    init(coordinateString: String) {
        self.coordinateString = coordinateString.trimWhitespace()
        //print("Trimmed: \(self.coordinateString)")
        self.workingString = self.coordinateString.utf8CString
    }
    
    func makeIterator() -> CoordinateLexer {
        return CoordinateLexer(coordinateString: self.coordinateString)
    }
    
    mutating func next() -> Element? {
        
        var didParseX = false
        var returnPoint = CGPoint.zero
        
        while self.interatorIndex < self.workingString.count - 1 {
            
            switch self.currentCharacter {
            case DCharacter.comma.rawValue, DCharacter.space.rawValue:
                //print("Is comma: \(self.currentCharacter == DCharacter.comma.rawValue)")
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
        
        /*
        let characterCount = self.workingString.count - 1
        
        guard self.stringIndex + 1 < characterCount else {
            return nil
        }
        
        self.xNumber.removeAll()
        self.yNumber.removeAll()
        
        var numberParsed = 0
        
        var thisCharacter = self.workingString[self.stringIndex]
        while self.stringIndex < characterCount { // SPACE or COMMA separator
            
            switch thisCharacter {
            case DCharacter.space.rawValue:
                
            case DCharacter.comma.rawValue:
                
            default:
                <#code#>
            }
            
            if (thisCharacter ==  || thisCharacter == DCharacter.comma.rawValue) {
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
        */
    }
}



