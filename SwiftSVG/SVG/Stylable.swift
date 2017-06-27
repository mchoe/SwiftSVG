//
//  Stylable.swift
//  SwiftSVG
//
//  Created by tarragon on 6/25/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import Foundation

private struct StylableConstants {
    static let attributesRegex = "(((\\w+)-?(\\w*)?):?([ #\\w]*\\.?\\w+))"
}

protocol Stylable { }

extension Stylable where Self : SVGElement {
    
    var styleAttributes: [String : (String) -> ()] {
        return [
            "style": self.style,
        ]
    }
    
    func style(_ styleString: String) {
        
        do {
            let regex = try NSRegularExpression(pattern: StylableConstants.attributesRegex, options: .caseInsensitive)
            let matches = regex.matches(in: styleString, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, styleString.utf8.count))
            
            matches.forEach({ (thisMatch) in
                let nameRange = thisMatch.rangeAt(2)
                let valueRange = thisMatch.rangeAt(5)
                let styleName = styleString[nameRange.location..<nameRange.location + nameRange.length]
                let valueString = styleString[valueRange.location..<valueRange.location + valueRange.length].trimWhitespace()
                
                guard let thisClosure = self.supportedAttributes[styleName] else {
                    print("Couldn't set: \(styleName)")
                    return
                }
                thisClosure?(valueString)
                
            })
            
        } catch {
            print("Couldn't parse style string: \(styleString)")
        }
    }
}
