SwiftSVG
========

A simple SVG parser written in Swift.

Boom. SVG.

Table of Contents
-----------------

- [Install](#Install)
- [Usage](#Usage)
	- [String+SVG](#String+SVG)
	- [UIBezierPath+SVG](#UIBezierPath+SVG)
	- [CAShapeLayer+SVG](#CAShapeLayer+SVG)
	- [UIView+SVG](#UIView+SVG)
	- [SVGView](#SVGView)
- [License](#License)


Install
-------

SwiftSVG is meant to be dropped in to any project. Pick and choose the files you need, but you can install all the extensions via [CocoaPods](http://cocoapods.org/):

	pod install 'SwiftSVG'


Usage
-----

SwiftSVG provides multiple interfaces to parse single path strings and SVG files using NSXMLParser. 

####String+SVG####

The simplest way is to parse raw path data using `parseSVGPath()`

```swift
let examplePathData: String = "M150 0 L75 200 L225 200 Z"
let parsedPath: UIBezierPath = parseSVGPath(examplePathData)
```

You can optionally provide a `UIBezierPath` for the second argument if you want to fill in an existing path instead of having one returned, say if you want to append to an existing path:

```swift
let pathToAppendTo = UIBezierPath()
let parsedPath: UIBezierPath = parseSVGPath(examplePathData, forPath: pathToAppendTo)
```

Or, you can use the String extension `pathFromSVGString()`:

```swift
let parsedPath: UIBezierPath = examplePathData.pathFromSVGString()
```

####UIBezierPath+SVG####

SwiftSVG also provides a convenience initializer for UIBezierPath that allows you to either create a `UIBezierPath` from a path string or from an SVG file:

```swift
// UIBezierPath Convenience Initializer
let parsedPath = UIBezierPath(pathString: examplePathData)

// Path from SVG File
let svgURL = NSBundle.mainBundle().URLForResource("example", withExtension: "svg")
let pathFromSVGFile = UIBezierPath.pathWithSVGURL(svgURL)
```

####CAShapeLayer+SVG####

You can create a `CAShapeLayer` from a path string or SVG file. You can optionally provide fill and stroke colors, and a stroke width. Fill colors are read automatically if provided as an attribute on the path element. The fill attribute must be supplied as a hex value:

	<path fill="#FF0066" d="M150 0 L75 200 L225 200 Z">

####UIView+SVG####

####SVGView####


License
-------

SwiftSVG is released under the [MIT License](https://github.com/mchoe/SwiftSVG/blob/master/LICENSE).



