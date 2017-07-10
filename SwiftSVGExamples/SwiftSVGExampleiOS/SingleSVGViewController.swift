//
//  ViewSVGViewController.swift
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
        let svgView = SVGView(SVGData: svgData) { (svgLayer) in
            //svgLayer.fillColor = UIColor(red:0.37, green:0.10, blue:0.55, alpha:1.00).cgColor
            //svgLayer.strokeColor = UIColor(red:0.37, green:0.10, blue:0.55, alpha:1.00).cgColor
            //svgLayer.lineWidth = 1.0
            print("Finished: \(svgLayer.frame)")
        }
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


