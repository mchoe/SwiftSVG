//
//  GithubViewController.swift
//  SwiftSVGExamples
//
//  Created by tarragon on 7/7/17.
//  Copyright © 2017 Michael Choe. All rights reserved.
//

import SwiftSVGiOS
import UIKit

class GithubViewController: UIViewController {
    
    
    struct CellItem {
        let render: (CGSize) -> UIView
    }
    
    lazy var collectionViewData: [CellItem] = {
        let returnData = [
            CellItem(render: { (cellSize) -> UIView in
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
                let renderedLayer = SVGView(SVGURL: svgURL!) { (svgLayer) in
                    svgLayer.resizeToFit(CGRect(x: 0, y: 0, width: cellSize.width, height: cellSize.height))
                    returnView.layer.addSublayer(svgLayer)
                }
                return returnView
            }),
            CellItem(render: { (cellSize) -> UIView in
                let svgURL = Bundle.main.url(forResource: "pizza", withExtension: "svg")
                let data = try! Data(contentsOf: svgURL!)
                let svgView = UIView(SVGData: data)
                return svgView
            }),
            CellItem(render: { (cellSize) -> UIView in
                let svgView = UIView(svgNamed: "johnny-automatic-open-mouth")
                return svgView!
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
        let halfWidth = collectionView.bounds.size.width / 2
        let cellSize = CGSize(width: halfWidth, height: halfWidth)
        returnCell?.svgView.addSubview(thisItem.render(cellSize))
        return returnCell!
    }
    
}

extension GithubViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let halfWidth = collectionView.bounds.size.width / 2
        return CGSize(width: halfWidth, height: halfWidth)
    }
    
}
