//
//  ViewSVGViewController.swift
//  SwiftSVGExamples
//
//  Created by Michael Choe on 6/4/17.
//  Copyright © 2017 Michael Choe. All rights reserved.
//

import SwiftSVGiOS
import UIKit

class SingleSVGViewController: UIViewController {

    @IBOutlet weak var canvasView: UIView!
    
    // https://openclipart.org/download/282489/slide.svg
    // https://openclipart.org/download/282246/Cup.svg
    // https://openclipart.org/download/9214/johnny-automatic-wise-owl-on-books.svg
    // https://openclipart.org/download/181651/manhammock.svg
    // https://openclipart.org/download/184631/bigbull.svg
    // https://openclipart.org/download/233724/Viking-by-Rones.svg
    // https://openclipart.org/download/189987/1389370959.svg
    // https://openclipart.org/download/228880/Diverse-Kids.svg
    
    var svgURL = URL(string: "https://openclipart.org/download/228880/Diverse-Kids.svg")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        guard let url = self.svgURL else {
            return
        }
        
        let svgData = try! Data(contentsOf: url)
        let svgView = SVGView(SVGData: svgData)
        //let svgView = SVGView(SVGURL: url)
        self.canvasView.addSubview(svgView)
        
        //let svgLayer = CALayer(SVGURL: url)
        //self.view.layer.addSublayer(svgLayer)
        
    }

}

extension SingleSVGViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.canvasView
    }
    
}


