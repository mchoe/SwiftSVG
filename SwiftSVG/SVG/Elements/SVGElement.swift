//
//  SVGElement.swift
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



#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

// TODO:
// NOTE: For the supported attributes, I wanted to use a little currying
// magic so that it could potentially take any method on any arbitrary 
// type. The type signature would look like this `[String : (Self) -> (String) -> ()]`
// 
// Unfortunately, I couldn't get this to work because the curried type wouldn't be known
// at runtime. Understandable, and my first inclination was to use type erasure to no avail. 
// I think if and when Swift adopts language level type erasure, then
// this will be possible. I'm flagging this here to keep that in mind because
// I think that will yield a cleaner design and implementation.
//
// -Michael Choe 06.03.17


protocol SVGElement {
    static var elementName: String { get }
    var supportedAttributes: [String : ((String) -> ())?] { get set }
    
    func didProcessElement(in container: SVGContainerElement?)
}


