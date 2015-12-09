
![SwiftSVG Logo](/images/SwiftSVG-Logo.png)

SwiftSVG
========

A simple SVG parser written in Swift. Quickly goes through SVG path data and outputs

Boom. SVG.

SwiftSVG is part of a larger library I created called [Breakfast](https://github.com/mchoe/Breakfast). I created a separate project because I would like to support as much as the SVG specification as possible. As such, I wanted a place to track issues related specifically to that goal and any changes here will eventually be integrated into Breakfast.

I also wanted to make it possible to use SwiftSVG without installing the full Breakfast Framework, so feel free to use only SwiftSVG in your next project. It was meant to be as lightweight and modular as possible.

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

SwiftSVG is meant to be dropped in to any project. Pick and choose the files you need, but you can install all the extensions via [Carthage](https://github.com/Carthage/Carthage):
	
	github "mchoe/SwiftSVG" ~> 1.0


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

#####Output:#####
![This is not a triangle](/images/triangle.png)

***

####UIBezierPath+SVG####

SwiftSVG also provides a convenience initializer for UIBezierPath that allows you to either create a `UIBezierPath` from a path string or from an SVG file:

```swift
let shapeLayer = CAShapeLayer()

// UIBezierPath Convenience Initializer
let chair = "M109.946,26.218c-3.301-0.265-13.071-1.735-18.571-5.305c-3.194-2.067-5.435-5.013-7.805-8.129C79.162,6.986,73.895-0.006,61.342,0l-8.135,0.001C40.096-0.008,33.121,9.84,30.883,12.784c-0.009,0.012-0.018,0.023-0.027,0.036l0.024-0.156c-2.372,3.118-4.609,6.062-7.802,8.128c-5.503,3.57-15.274,5.04-18.574,5.307c-2.467,0.196-4.4,2.201-4.505,4.674v3.618c2.401,0.299,9.167,0.532,9.167,22.157h0.004c0,0.041,0,0.08,0,0.12c0,21.011,16.515,28.312,27.254,29.596l-20.853,57.539c-0.922,2.547,0.392,5.354,2.938,6.273c0.552,0.203,1.114,0.299,1.667,0.299c2.004,0,3.886-1.24,4.608-3.236l11.951-32.98l20.624-13.093l20.613,13.093l11.955,32.98c0.72,1.996,2.603,3.236,4.605,3.236c0.555,0,1.118-0.096,1.668-0.299c2.546-0.922,3.859-3.729,2.937-6.273L78.285,86.247c10.608-1.325,26.998-8.646,26.998-29.578c0-21.626,6.769-21.858,9.167-22.158v-3.617C114.344,28.422,112.411,26.416,109.946,26.218z M40.382,104.108l4.073-11.239l6.81,4.324L40.382,104.108z M46.733,86.576l0.034-0.098h13.155c0.003,0,0.006-0.003,0.011-0.003h8.015l0.035,0.098l-10.622,6.753L46.733,86.576z M63.453,97.193l6.812-4.324l4.068,11.239L63.453,97.193z M95.482,56.669c0,7.397-2.877,12.033-6.448,14.975c-0.351-6.097-14.442-11.002-31.81-11.002c-17.328,0-31.39,4.884-31.799,10.959c-3.578-2.943-6.458-7.578-6.458-14.932c0-1.353-0.028-2.645-0.083-3.88c-0.36-8.603-1.957-14.43-3.937-18.384c4.379-1.025,9.458-2.671,13.464-5.268c4.623-2.999,7.624-6.945,10.269-10.421c4.143-5.457,6.9-9.156,14.431-8.917l8.321-0.001c7.451-0.076,10.187,3.464,14.336,8.918c2.648,3.477,5.646,7.422,10.27,10.421c4.023,2.605,9.123,4.256,13.513,5.28C97.271,38.919,95.482,45.884,95.482,56.669z"
let parsedPath = UIBezierPath(pathString: chair)
shapeLayer.path = parsedPath

// Path from SVG File
let svgURL = NSBundle.mainBundle().URLForResource("chair", withExtension: "svg")
let pathFromSVGFile = UIBezierPath.pathWithSVGURL(svgURL)
shapelayer.path = pathFromSVGFile
```

#####Output:#####
![This is not a chair](/images/chair.png)

***

####CAShapeLayer+SVG####

You can create a `CAShapeLayer` from a path string or SVG file:

```swift
// From Path String
let pizza = "M185.158,60.775l-0.698-4.896c-0.675-3.783-1.681-7.316-3.208-10.128c-5.67-10.472-48.894-65.225-61.319-68.777c-2.081-0.595-7.61-1.974-14.101-1.974c-8.908,0-16.174,2.602-21.013,7.528c-4.369,4.442-6.737,10.636-7.054,18.44c-6.133,2.803-21.237,10.434-25.399,19.22c-2.099,4.433-10.814,8.388-17.817,11.571c-5.636,2.561-10.503,4.771-13.48,7.521c-1.598,1.476-3.766,3.669-6.267,6.202C7.681,52.688-3.083,63.58-9.476,66.273c-7.238,3.047-12.022,7.993-12.489,12.911c-0.249,2.633,0.84,5.033,2.917,6.415c3.74,2.492,17.312,4.357,26.946,4.357c2.032,0,3.994-0.077,5.819-0.237c5.479-0.503,25.312-0.905,44.213-0.905c22.609,0,32.813,0.55,34.684,1.023c3.92,0.995,7.436,0.942,12.58,0.554c3.368-0.246,7.289-0.536,13.075-0.435c5.942,0.118,11.431,0.349,15.948,0.544c4.02,0.169,7.287,0.312,9.459,0.312c1.462,0,2.392-0.06,3.031-0.178c0.235-0.03,1.45-0.127,7.174-0.127c10.246,0,26.791,0.305,26.798,0.305c2.165,0.031,3.745-1.457,4-3.467C184.779,86.538,186.425,73.199,185.158,60.775z M71.908,23.986c8.08-2.059,15.464-0.457,16.491,3.583c1.03,4.036-4.682,8.985-12.758,11.041c-8.079,2.059-15.461,0.459-16.491-3.582C58.125,30.993,63.836,26.049,71.908,23.986z M33.1,44.006c7.807-0.659,14.386,2.201,14.691,6.397c0.312,4.193-5.765,8.144-13.568,8.805c-7.809,0.66-14.387-2.201-14.691-6.4C19.223,48.61,25.297,44.671,33.1,44.006zM122.67,80.658c-0.223,0.481-0.329,0.981-0.344,1.473c-1.275-0.034-2.572-0.064-3.897-0.094c-0.921-0.019-1.791-0.024-2.629-0.024c-4.794,0-8.346,0.267-11.199,0.479c-4.11,0.311-6.946,0.45-10.042-0.332c-4.137-1.05-22.203-1.268-36.628-1.268c-19.423,0-39.159,0.41-44.93,0.938c-1.345,0.124-2.81,0.158-4.291,0.178C23.522,76.224,40.985,70.605,46.118,71.8c3.038,0.724,5.305,1.489,7.307,2.163c4.688,1.583,8.4,2.834,15.098,0.738c1.88-0.587,3.815-1.356,5.77-2.142c6.874-2.748,11.313-4.229,15.043-1.614c8.523,5.97,15.491,4.944,22.228,3.969l0.526-0.071c5.021-0.737,10.051-0.055,11.217,1.509C123.833,77.053,123.603,78.625,122.67,80.658z M111.153,57.015c-10.024,0.743-18.474-2.396-18.876-7.028c-0.406-4.629,7.39-8.989,17.41-9.734c10.022-0.752,18.479,2.397,18.881,7.027C128.974,51.904,121.175,56.27,111.153,57.015zM142.469,51.189c-1.634-5.537-4.103-11.182-7.809-14.091c-9.188-7.221-20.624-16.848-25.173-22.223C108.884,14.164,96.799,0.084,85.878-0.92c0.518-4.697,2.036-8.397,4.593-10.994c4.188-4.261,10.668-5.158,15.364-5.158c5.493,0,10.16,1.168,11.919,1.667c7.153,2.042,38.85,39.213,51.926,57.785c-4.398-1.786-9.489-2.251-15.089-0.152C148.921,44.351,145.108,47.405,142.469,51.189z M177.185,82.824c-5.475-0.083-15.981-0.236-23.304-0.236c-6.653,0-7.854,0.121-8.513,0.236c-0.301,0.047-0.774,0.07-1.361,0.079c0.029-0.512,0.06-1.065,0.077-1.571c0.924-18.863,1.812-27.383,13.295-31.685c9.708-3.65,16.787,4.983,19.528,9.136C178.086,66.809,177.729,76.612,177.185,82.824z"
let svgShapeLayer = CAShapeLayer(pathString: pizza)

// From SVG File
let svgURL = NSBundle.mainBundle().URLForResource("pizza", withExtension: "svg")
let svgShapeLayerFromFile = CAShapeLayer(SVGURL: svgURL)
```

#####Output:#####
![This is not delicious pizza](/images/pizza.png)

Fill colors are read automatically if provided as an attribute on the path element. The fill attribute must be supplied as a hex value:
```html
<path fill="#FF0066" d="M150 0 L75 200 L225 200 Z">
```

***

####UIView+SVG####

A UIView convenince initializer is provided as well. Same thing goes as with CAShapeLayer, you can supply a path string or an SVG file:

```swift
// From Path String
let sockPuppet = "M185.158,60.775l-0.698-4.896c-0.675-3.783-1.681-7.316-3.208-10.128c-5.67-10.472-48.894-65.225-61.319-68.777c-2.081-0.595-7.61-1.974-14.101-1.974c-8.908,0-16.174,2.602-21.013,7.528c-4.369,4.442-6.737,10.636-7.054,18.44c-6.133,2.803-21.237,10.434-25.399,19.22c-2.099,4.433-10.814,8.388-17.817,11.571c-5.636,2.561-10.503,4.771-13.48,7.521c-1.598,1.476-3.766,3.669-6.267,6.202C7.681,52.688-3.083,63.58-9.476,66.273c-7.238,3.047-12.022,7.993-12.489,12.911c-0.249,2.633,0.84,5.033,2.917,6.415c3.74,2.492,17.312,4.357,26.946,4.357c2.032,0,3.994-0.077,5.819-0.237c5.479-0.503,25.312-0.905,44.213-0.905c22.609,0,32.813,0.55,34.684,1.023c3.92,0.995,7.436,0.942,12.58,0.554c3.368-0.246,7.289-0.536,13.075-0.435c5.942,0.118,11.431,0.349,15.948,0.544c4.02,0.169,7.287,0.312,9.459,0.312c1.462,0,2.392-0.06,3.031-0.178c0.235-0.03,1.45-0.127,7.174-0.127c10.246,0,26.791,0.305,26.798,0.305c2.165,0.031,3.745-1.457,4-3.467C184.779,86.538,186.425,73.199,185.158,60.775z M71.908,23.986c8.08-2.059,15.464-0.457,16.491,3.583c1.03,4.036-4.682,8.985-12.758,11.041c-8.079,2.059-15.461,0.459-16.491-3.582C58.125,30.993,63.836,26.049,71.908,23.986z M33.1,44.006c7.807-0.659,14.386,2.201,14.691,6.397c0.312,4.193-5.765,8.144-13.568,8.805c-7.809,0.66-14.387-2.201-14.691-6.4C19.223,48.61,25.297,44.671,33.1,44.006zM122.67,80.658c-0.223,0.481-0.329,0.981-0.344,1.473c-1.275-0.034-2.572-0.064-3.897-0.094c-0.921-0.019-1.791-0.024-2.629-0.024c-4.794,0-8.346,0.267-11.199,0.479c-4.11,0.311-6.946,0.45-10.042-0.332c-4.137-1.05-22.203-1.268-36.628-1.268c-19.423,0-39.159,0.41-44.93,0.938c-1.345,0.124-2.81,0.158-4.291,0.178C23.522,76.224,40.985,70.605,46.118,71.8c3.038,0.724,5.305,1.489,7.307,2.163c4.688,1.583,8.4,2.834,15.098,0.738c1.88-0.587,3.815-1.356,5.77-2.142c6.874-2.748,11.313-4.229,15.043-1.614c8.523,5.97,15.491,4.944,22.228,3.969l0.526-0.071c5.021-0.737,10.051-0.055,11.217,1.509C123.833,77.053,123.603,78.625,122.67,80.658z M111.153,57.015c-10.024,0.743-18.474-2.396-18.876-7.028c-0.406-4.629,7.39-8.989,17.41-9.734c10.022-0.752,18.479,2.397,18.881,7.027C128.974,51.904,121.175,56.27,111.153,57.015zM142.469,51.189c-1.634-5.537-4.103-11.182-7.809-14.091c-9.188-7.221-20.624-16.848-25.173-22.223C108.884,14.164,96.799,0.084,85.878-0.92c0.518-4.697,2.036-8.397,4.593-10.994c4.188-4.261,10.668-5.158,15.364-5.158c5.493,0,10.16,1.168,11.919,1.667c7.153,2.042,38.85,39.213,51.926,57.785c-4.398-1.786-9.489-2.251-15.089-0.152C148.921,44.351,145.108,47.405,142.469,51.189z M177.185,82.824c-5.475-0.083-15.981-0.236-23.304-0.236c-6.653,0-7.854,0.121-8.513,0.236c-0.301,0.047-0.774,0.07-1.361,0.079c0.029-0.512,0.06-1.065,0.077-1.571c0.924-18.863,1.812-27.383,13.295-31.685c9.708-3.65,16.787,4.983,19.528,9.136C178.086,66.809,177.729,76.612,177.185,82.824z"
let svgView = UIView(pathString: sockPuppet)

// From SVG File
let svgURL = NSBundle.mainBundle().URLForResource("sockPuppet", withExtension: "svg")
let svgViewFromFile = UIView(SVGURL: svgURL)
```

#####Output:#####
![This is not a sock puppet](/images/sockPuppet.png)

***

####SVGView####

Finally, SwiftSVG provides a `UIView` subclass that is `IBInspectable` and `IBDesignable`. Simply add a view to your storyboard and use the SVGView subclass as you class name. Then put the name of your SVG file in your bundle in the `IBInspectable` property "SVGName"

![Screenshot of SVGView in Interface Builder](/images/svgViewScreenshot.png)

*** safar

Credits
-------

- [Pizza SVG](http://thenounproject.com/term/pizza/7914/) - Justin Alexander
- [Sock Puppet SVG](http://thenounproject.com/term/sock-puppet/30622/) - Myles McCoy

License
-------

SwiftSVG is released under the [MIT License](https://github.com/mchoe/SwiftSVG/blob/master/LICENSE).



