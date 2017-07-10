//
//  Stylable.swift
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
