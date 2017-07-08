//
//  ViewController.swift
//  SwiftSVGExampleiOS
//
//  Created by Michael Choe on 4/5/16.
//  Copyright © 2016 Michael Choe. All rights reserved.
//

import UIKit

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

class ViewController: UIViewController {
    
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

