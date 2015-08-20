//
//  CollectionViewController.swift
//  WOWRefreshViewDemo
//
//  Created by Zhou Hao on 19/8/15.
//  Copyright © 2015 Zhou Hao. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    var data = [String]()
    var refreshView : WOWRefreshView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshView = WOWRefreshView(scrollView: self.collectionView,direction: .Right,completion: { () -> Void in
            self.reloadData()
        })
        
        refreshView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
        refreshView.tintColor = UIColor.orangeColor()
        
        loadData()
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionView", forIndexPath: indexPath) as! CollectionCell
        cell.titleLabel.text = data[indexPath.row]
        return cell
    }

    func loadData() {
        
        refreshView.startRefreshing()
        reloadData()
    }
    
    func reloadData() {
        
        GCD.delay(2) { () -> () in
            self.data = [String]()
            self.data.append("data 1")
            self.data.append("data 2")
            self.data.append("data 3")
            self.data.append("data 4")
            self.data.append("data 5")
            self.data.append("data 6")
            self.data.append("data 7")
            self.data.append("data 8")
            self.data.append("data 9")
            self.data.append("data 10")
            
            self.collectionView.reloadData()
            self.refreshView.endRefreshing()
        }
    }
    
}
