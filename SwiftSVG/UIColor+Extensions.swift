//
//  UIColor+Extensions.swift
//  Breakfast
//
//  This file is from a dynamic framework I created called Breakfast. I included the
//  files here so you didn't have to install another Cocoapod to use and test out
//  this library. As such, this file may not be maintained as well, so use it at
//  your own risk.
//
//  SwiftSVG is one of the many great tools that are a part of Breakfast. If you're
//  looking for a great start to your next Swift project, check out Breakfast.
//  It contains classes and helper functions that will get you started off right.
//  https://github.com/mchoe/Breakfast
//
//
//  Copyright (c) 2015 Michael Choe
//  http://www.straussmade.com/
//  http://www.twitter.com/_mchoe
//  http://www.github.com/mchoe
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

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

public extension UIColor {
    
    convenience init(hexString: String) {
        
        var workingString = hexString
        if workingString.hasPrefix("#") {
            workingString = String(workingString.characters.dropFirst())
        }
        
        var hexRed = "00"
        var hexGreen = "00"
        var hexBlue = "00"
        
        if workingString.characters.count == 6 {
			var range = workingString.startIndex ..< workingString.index(workingString.startIndex, offsetBy: 2)
			hexRed = workingString.substring(with: range)
			range = workingString.index(workingString.startIndex, offsetBy: 2) ..< workingString.index(workingString.startIndex, offsetBy: 4)
			hexGreen = workingString.substring(with: range)
			range = workingString.index(workingString.startIndex, offsetBy: 4) ..< workingString.index(workingString.startIndex, offsetBy: 6)
			hexBlue = workingString.substring(with: range)
        } else if workingString.characters.count == 3 {
            let redValue = workingString[0]
            let greenValue = workingString[1]
            let blueValue = workingString[2]
            hexRed = "\(redValue)\(redValue)"
            hexGreen = "\(greenValue)\(greenValue)"
            hexBlue = "\(blueValue)\(blueValue)"
        }
        
        let red = CGFloat(hexRed.hexToInteger())
        let green = CGFloat(hexGreen.hexToInteger())
        let blue = CGFloat(hexBlue.hexToInteger())
        
        self.init(red: CGFloat(red / 255.0), green: CGFloat(green / 255.0), blue: CGFloat(blue / 255.0), alpha: 1.0)
    }
}


