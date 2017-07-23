
![SwiftSVG Logo](https://raw.githubusercontent.com/mchoe/SwiftSVG/master/images/SwiftSVG-Logo.png)

SwiftSVG
========

A simple single pass SVG parser written in Swift.

I also wanted to make it possible to use SwiftSVG without installing the full Breakfast Framework, so feel free to use only SwiftSVG in your next project. It was meant to be as lightweight and modular as possible.


Development Priorities
======================

Developer Joy really encapsulates a few different concepts:
	1. Clarity and an ability to easily reason about the code
	2. Code length and DRY principles
	3. Maintainability and tech debt
	4. API Stability
	4. Stability and Predicatability

To me, code at its best seamlessly marries performance with Developer Joy where both goals are equally being advanced. The reality however, means that compromises may have to made to maximize another goal.


Features
========

- Multiple interface options (String, UIBezierPath, CAShapeLayer, UIView, and IBDesignable Interface Builder subclass)
- Strives to be performant. Takes only one pass through path string. 
- Low memory usage

Table of Contents
-----------------

- [Install](#Install)
- [Usage](#Usage)
	- [String+SVG](#String+SVG)
	- [UIBezierPath+SVG](#UIBezierPath+SVG)
	- [CAShapeLayer+SVG](#CAShapeLayer+SVG)
	- [UIView+SVG](#UIView+SVG)
	- [SVGView](#SVGView)
- [Credits](#Credits)
- [License](#License)


Install
-------

Install via Cocoapods:
	
	pod 'SwiftSVG', '~> 2.0'

Carthage:

	github "mchoe/SwiftSVG" ~> 2.0

Then import the framework into your project:

	import SwiftSVG

**For projects currently using 1.0**: SwiftSVG 2.x is a major rewrite of the library. For most use cases, you should be able to upgrade to 2.0 with little to no changes to your code. However, there are breaking changes 


Usage
-----

### UIView+SVG

The easiest way to create an SVG file is to use the UIView extension:
```swift
let fistBump = UIView(SVGNamed: "fistbump")     // In the main bundle
self.addSubview(fistBump)
```
#### Output:
![Put it here!](https://raw.githubusercontent.com/mchoe/SwiftSVG/master/images/fistBump.png)

SwiftSVG also provides the following convenience initializers:
```swift
func UIView(SVGNamed: String)
func UIView(SVGURL: URL)
func UIView(SVGData: Data)
```

All of these initializers will parse a file located in the main bundle, a bundle of your own choosing, or on the web. It will parse the file asynchronously and optionally takes a completion block, passing a `SVGLayer` that's sized to aspect fit the UIView's superview. Whether you pass a completion block or not, SwiftSVG will resize the layer and add it to the view's sublayers.

You can optionally pass an `SVGParser` object if you want to reuse the same parser for various SVG files or want to roll your own using a third-party XML parser. By default, SwiftSVG uses a subclass of Foundation's `XMLParser` using all the supported elements and attributes called `NSXMLSVGParser`. You can also optionally setup your own `NSXMLSVGParser` passing a `SVGParserSupportedElements` struct that will parse only the elements and attributes of your choosing.




Credits
-------

- [Fist](https://thenounproject.com/term/fist/303025/) - Francesco Cesqo Stefanini
- [Pizza SVG](http://thenounproject.com/term/pizza/7914/) - Justin Alexander
- [Sock Puppet SVG](http://thenounproject.com/term/sock-puppet/30622/) - Myles McCoy

License
-------

SwiftSVG is released under the [MIT License](https://github.com/mchoe/SwiftSVG/blob/master/LICENSE).


