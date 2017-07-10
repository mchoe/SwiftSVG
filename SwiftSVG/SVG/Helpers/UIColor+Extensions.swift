//
//  UIColor+Extensions.swift
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



#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif


let namedColors: [String : CGColor] = [
    "none": UIColor.clear.cgColor
]

public extension UIColor {
    
    convenience init?(svgString: String) {
        if svgString.hasPrefix("#") {
            self.init(hexString: svgString)
            return
        }
        
        if svgString.hasPrefix("rgb") {
            self.init(rgbString: svgString)
            return
        }
        
        self.init(named: svgString)
    }
    
    convenience init?(hexString: String) {
        
        var workingString = hexString
        if workingString.hasPrefix("#") {
            workingString = String(workingString.characters.dropFirst())
        }
        
        var hexArray = [CChar]()
        var colorArray = [CGFloat]()
        let utf8View = workingString.utf8CString.dropLast()
        
        if utf8View.count == 6 {
            for (index, thisScalar) in utf8View.enumerated() {
                if index % 2 == 0 {
                    hexArray.removeAll()
                    hexArray.append(thisScalar)
                } else {
                    hexArray.append(thisScalar)
                    guard let colorFloat = CGFloat(byteArray: hexArray, base:16) else {
                        continue
                    }
                    colorArray.append(colorFloat)
                }
            }
        } else if utf8View.count == 3 {
            for thisScalar in utf8View {
                hexArray.removeAll()
                hexArray.append(thisScalar)
                hexArray.append(thisScalar)
                guard let colorFloat = CGFloat(byteArray: hexArray, base:16) else {
                    continue
                }
                colorArray.append(colorFloat)
            }
        } else {
            return nil
        }
        self.init(red: colorArray[0] / 255.0, green: colorArray[1] / 255.0, blue: colorArray[2] / 255.0, alpha: 1.0)
    }
    
    convenience init(rgbString: String) {
        let valuesString = rgbString.characters.dropFirst(4).dropLast()
        let colorsArray = valuesString.split(separator: ",").map { (numberString) -> CGFloat in
            return CGFloat(String(numberString).trimmingCharacters(in: CharacterSet.whitespaces))!
        }
        self.init(red: colorsArray[0] / 255.0, green: colorsArray[1] / 255.0, blue: colorsArray[2] / 255.0, alpha: (colorsArray.count > 3 ? colorsArray[3] / 1.0 : 1.0))
    }
    
    convenience init?(named: String) {
        guard let namedColor = namedColors[named] else {
            return nil
        }
        self.init(cgColor: namedColor)
    }
    
    
}


