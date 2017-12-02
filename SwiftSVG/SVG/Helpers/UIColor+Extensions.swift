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

/**
 A struct that represents named colors as listed [here](https://www.w3.org/TR/SVGColor12/#icccolor)
 */
struct NamedColors {
    
    /// Dictionary of named colors
    private let colorDictionary = [
        "aliceblue": UIColor(red: 240.0 / 255.0, green: 248.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0).cgColor,
        "cyan": UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor,
        "none": UIColor.clear.cgColor
    ]
    
    /// Subscript to access the named color. Must be one of the officially supported values listed [here](https://www.w3.org/TR/SVGColor12/#icccolor)
    subscript(index: String) -> CGColor? {
        return self.colorDictionary[index]
    }
}


public extension CGColor {
    
    /**
     Lazily loaded instance of `NamedColors`
     */
    fileprivate static var named: NamedColors {
        return NamedColors()
    }
}

public extension UIColor {
    
    /**
     Convenience initializer that creates a new UIColor based on a 3 or 6 digit hex string, integer functional, or named string.
     - Parameter svgString: A hex, integer functional, or named string
     - SeeAlso: See officially supported color formats: [https://www.w3.org/TR/SVGColor12/#sRGBcolor](https://www.w3.org/TR/SVGColor12/#sRGBcolor)
     */
    internal convenience init?(svgString: String) {
        if svgString.hasPrefix("#") {
            self.init(hexString: svgString)
            return
        }
        
        if svgString.hasPrefix("rgb") {
            self.init(rgbString: svgString)
            return
        }
        
        if svgString.hasPrefix("rgba") {
            self.init(rgbaString: svgString)
            return
        }
        
        self.init(named: svgString)
    }
    
    /**
     Convenience initializer that creates a new UIColor based on a 3 or 6 digit hex string. The leading `#` character is optional
     - Parameter hexString: A 3 or 6 digit hex string
     - Parameter alpha: Optional alpha value
     */
    internal convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        
        var workingString = hexString
        if workingString.hasPrefix("#") {
            workingString = String(workingString.dropFirst())
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
        self.init(red: colorArray[0] / 255.0, green: colorArray[1] / 255.0, blue: colorArray[2] / 255.0, alpha: alpha)
    }
    
    /**
     Convenience initializer that creates a new UIColor from a integer functional, taking the form `rgb(rrr, ggg, bbb)`
     */
    internal convenience init(rgbString: String) {
        let valuesString = rgbString.dropFirst(4).dropLast()
        self.init(colorValuesString: valuesString)
    }
    
    /**
     Convenience initializer that creates a new UIColor from an integer functional, taking the form `rgba(rrr, ggg, bbb, <alphavalue>)`
     */
    internal convenience init(rgbaString: String) {
        let valuesString = rgbaString.dropFirst(5).dropLast()
        self.init(colorValuesString: valuesString)
    }
    
    /// :nodoc:
    private convenience init(colorValuesString: Substring) {
        let colorsArray = colorValuesString
            .split(separator: ",")
            .map { (numberString) -> CGFloat in
                return CGFloat(String(numberString).trimmingCharacters(in: CharacterSet.whitespaces))!
            }
        self.init(red: colorsArray[0] / 255.0, green: colorsArray[1] / 255.0, blue: colorsArray[2] / 255.0, alpha: (colorsArray.count > 3 ? colorsArray[3] / 1.0 : 1.0))
    }
    
    /**
     Convenience initializer that creates a new UIColor from a CSS3 named color
     - SeeAlso: See here for all the colors: [https://www.w3.org/TR/css3-color/#svg-color](https://www.w3.org/TR/css3-color/#svg-color)
     */
    public convenience init?(named: String) {
        guard let namedColor = CGColor.named[named] else {
            return nil
        }
        self.init(cgColor: namedColor)
    }
    
    
}


