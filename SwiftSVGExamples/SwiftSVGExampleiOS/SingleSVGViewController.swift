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
    
    var svgURL = URL(string: "https://openclipart.org/download/181651/manhammock.svg")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        /*
        guard let url = self.svgURL else {
            return
        }
        
        let svgView = UIView(SVGURL: url) { (svgLayer) in
            svgLayer.resizeToFit(self.canvasView.bounds)
        }
        svgView.backgroundColor = UIColor.blue
        self.canvasView.addSubview(svgView)
        */
        
        let svgURL = URL(string: "https://jbdujardin.com/test.svg")!
        let svgView = UIView(SVGURL: svgURL) { (svgLayer) in
            svgLayer.resizeToFit(CGRect(x: 0.0, y: 0.0, width: 320.0, height: 180.0))
        }
        svgView.frame = CGRect(x: 0.0, y: 0.0, width: 320.0, height: 180.0)
        self.canvasView.addSubview(svgView)
    }

}

extension SingleSVGViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.canvasView
    }
    
}


