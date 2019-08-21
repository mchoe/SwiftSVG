//
//  VariousViewController.swift
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

class VariousViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    struct TableItem {
        let url: URL
        let isDirectory: Bool
        let title: String
        
        init(_ url: URL, title: String, isDirectory: Bool = false) {
            self.isDirectory = isDirectory
            self.url = url
            self.title = title
        }
    }
    
    lazy var collectionViewData: [TableItem] = {
        guard let resourceURL = Bundle.main.resourceURL else {
            return [TableItem]()
        }
        let allResources = try! FileManager.default.contentsOfDirectory(at: resourceURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        
        return allResources
            .filter({ (thisURL) -> Bool in
                if thisURL.pathExtension == "svg" {
                    return true
                }
                return false
            })
            .filter({ (thisURL) -> Bool in
                if thisURL.lastPathComponent.contains("hawaiiFlowers") {
                    return true
                }
                return false
            })
            .sorted(by: {
                $0.lastPathComponent.lowercased() < $1.lastPathComponent.lowercased()
            })
            .map({ (thisURL) -> TableItem in
                return TableItem(thisURL, title: thisURL.lastPathComponent)
            })
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedIndexPath = self.collectionView.indexPathsForSelectedItems?.first else {
            return
        }
        let singleVC = segue.destination as? SingleSVGViewController
        let thisItem = self.collectionViewData[selectedIndexPath.item]
        singleVC?.svgURL = thisItem.url
    }

}

extension VariousViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionViewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let returnCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VariousCell", for: indexPath) as! VariousCell
        let thisItem = self.collectionViewData[indexPath.row]
        let thisView = UIView(SVGURL: thisItem.url) { (svgLayer) in
            svgLayer.resizeToFit(returnCell.bounds)
        }
        returnCell.svgView.addSubview(thisView)
        return returnCell
    }
    
}

extension VariousViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "variousToDetailSegue", sender: self)
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
}

extension VariousViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellDimension = collectionView.bounds.size.width * 0.45
        return CGSize(width: cellDimension, height: cellDimension)
    }
    
}
