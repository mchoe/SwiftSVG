//
//  StartViewController.swift
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



import UIKit


class StartViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    struct StartItem {
        let title: String
        let description: String
        let segueIdentifier: String
        let prepareForSegue: ((UIViewController) -> ())?
        
        init(title: String, description: String, segueIdentifier: String, prepareForSegue: ((UIViewController) -> ())? = nil) {
            self.title = title
            self.description = description
            self.segueIdentifier = segueIdentifier
            self.prepareForSegue = prepareForSegue
        }
    }
    
    lazy var tableData: [StartItem] = {
        
        let returnData = [
            StartItem(title: "Examples from GitHub", description: "All the examples on the SwiftSVG GitHub page showing the different interface options", segueIdentifier: "startToGithubSegue"),
            StartItem(title: "Rendering Verifications", description: "Lots of different examples, showing the support for various elements, attributes, and performance. This is the main set used to for visual QA. Tap through to see the selected item full size and zoom in to see the SVG up close.", segueIdentifier: "startToVariousSegue"),
            StartItem(title: "SVGView Example", description: "SVGViewExampleViewController - An example of using the SVGView in Interface Builder ", segueIdentifier: "startToSVGViewSegue"),
            StartItem(title: "Complex Example", description: "Example with complex paths and coloring to stretch the library's performance. It's a 7MB file that's downloaded from the web, so it will take a while to parse, so be patient. Try zooming in.", segueIdentifier: "startToSingleSegue") { (destinationVC) in
                (destinationVC as! SingleSVGViewController).svgURL = URL(string: "https://openclipart.org/download/280178/CigCardSilverGreyDorkingHen.svg")!
            }
        ]
        
        return returnData
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedIndexPath = self.tableView.indexPathForSelectedRow else {
            return
        }
        let selectedItem = self.tableData[selectedIndexPath.row]
        segue.destination.title = selectedItem.title
        selectedItem.prepareForSegue?(segue.destination)
    }
    
}

extension StartViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let returnCell = tableView.dequeueReusableCell(withIdentifier: "StartCell") as? StartCell
        let thisItem = self.tableData[indexPath.row]
        returnCell?.titleLabel.text = thisItem.title
        returnCell?.subtitleLabel.text = thisItem.description
        return returnCell!
    }
    
}

extension StartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thisItem = self.tableData[indexPath.row]
        self.performSegue(withIdentifier: thisItem.segueIdentifier, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
