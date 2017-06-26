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
    
    init(coordinateString: String) {
        self.coordinateString = coordinateString.trimWhitespace()
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



