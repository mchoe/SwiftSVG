//
//  GithubViewController.swift
//  SwiftSVGExamples
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



import SwiftSVG
import UIKit

class GithubViewController: UIViewController {
    
    
    struct CellItem {
        let render: (CGSize) -> UIView
    }
    
    lazy var collectionViewData: [CellItem] = {
        let returnData = [
            CellItem(render: { (cellSize) -> UIView in
                
                // Parsing a single path string syncronously
                
                let examplePathData: String = "M75 0 l75 200 L0 200 Z"
                let parsedPath: UIBezierPath = UIBezierPath(pathString: examplePathData)
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = parsedPath.cgPath
                let returnView = UIView()
                returnView.layer.addSublayer(shapeLayer)
                return returnView
            }),
            CellItem(render: { (cellSize) -> UIView in
                
                let svgURL = Bundle.main.url(forResource: "fistBump", withExtension: "svg")
                let returnView = UIView()
                let renderedLayer = CALayer(SVGURL: svgURL!) { (svgLayer) in
                    svgLayer.resizeToFit(CGRect(x: 0, y: 0, width: cellSize.width, height: cellSize.height))
                    returnView.layer.addSublayer(svgLayer)
                    //print("Parsed fist bump: \(returnView.layer.sublayers)")
                }
                //print("Dispatched: \(returnView.layer.sublayers)")
                return returnView
            }),
            CellItem(render: { (cellSize) -> UIView in
                
                // Example passing SVG Data
                
                let svgURL = Bundle.main.url(forResource: "pizza", withExtension: "svg")
                let data = try! Data(contentsOf: svgURL!)
                let svgView = UIView(SVGData: data) { (svgLayer) in
                    svgLayer.resizeToFit(CGRect(x: 0, y: 0, width: cellSize.width, height: cellSize.height))
                }
                return svgView
            }),
            CellItem(render: { (cellSize) -> UIView in
                
                // Simplest example of an SVG stored in the main bundle
                
                let svgView = UIView(SVGNamed: "sockPuppet")
                return svgView
            })
        ]
        return returnData
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension GithubViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionViewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let returnCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GithubCell", for: indexPath) as? GithubCell
        let thisItem = self.collectionViewData[indexPath.row]
        returnCell?.svgView.addSubview(thisItem.render(returnCell!.bounds.size))
        return returnCell!
    }
    
}

extension GithubViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let halfWidth = collectionView.bounds.size.width / 2
        return CGSize(width: halfWidth, height: halfWidth)
    }
    
}
