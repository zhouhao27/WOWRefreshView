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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        reloadData()
    }
    
    func reloadData() {
        
        data = [String]()
        data.append("data 1")
        data.append("data 2")
        data.append("data 3")
        data.append("data 4")
        data.append("data 5")
        data.append("data 6")
        data.append("data 7")
        data.append("data 8")
        data.append("data 9")
        data.append("data 10")
        
        collectionView.reloadData()
    }
    
}
