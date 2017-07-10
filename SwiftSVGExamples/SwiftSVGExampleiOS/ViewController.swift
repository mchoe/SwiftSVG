//
//  ViewController.swift
//  SwiftSVGExampleiOS
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



class ViewController: UIViewController {
    
    struct TableItem {
        let items: [URL]
        let isDirectory: Bool
        let title: String
        
        init(_ items: [URL], title: String, isDirectory: Bool = false) {
            self.isDirectory = isDirectory
            self.items = items
            self.title = title
        }
    }
    
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    lazy var tableData: [TableItem] = {
        guard let resourceURL = Bundle.main.resourceURL else {
            return [TableItem]()
        }
        
        let allResources = try! FileManager.default.contentsOfDirectory(at: resourceURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        let returnTableData = allResources
        .filter({ (thisURL) -> Bool in
            if thisURL.pathExtension == "svg" {
                return true
            }
            return false
        })
        .map({ (thisURL) -> TableItem in
            return TableItem([thisURL], title: thisURL.lastPathComponent)
        })
        
        //let githubExamples = TableItem(<#T##items: [URL]##[URL]#>, title: <#T##String?#>, isDirectory: <#T##Bool#>)
        //self.tableData.insert(<#T##newElement: TableItem##TableItem#>, at: <#T##Int#>)
        
        return returnTableData
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Files"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listToDetailSegue" {
            let viewSVGVC = segue.destination as! SingleSVGViewController
            let selectedItem = self.tableData[self.selectedIndexPath.row]
            viewSVGVC.svgURL = selectedItem.items.first!
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let returnCell = tableView.dequeueReusableCell(withIdentifier: "AllFilesCell")!
        let thisItem = self.tableData[indexPath.row]
        returnCell.textLabel?.text = thisItem.title
        return returnCell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "listToDetailSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

