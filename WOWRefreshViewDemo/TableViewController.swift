//
//  TableViewController.swift
//  WOWRefreshViewDemo
//
//  Created by Zhou Hao on 19/8/15.
//  Copyright © 2015 Zhou Hao. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var refreshView : WOWRefreshView!
    
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshView = WOWRefreshView(scrollView: self.tableView, direction: .Vertical, completion: { () -> Void in

            self.reloadData()
        })
        refreshView.backgroundColor = UIColor.lightGrayColor()
        refreshView.lineColor = UIColor.orangeColor()
        refreshView.lineWidth = 2
        loadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    // first load
    func loadData() {
        
        self.refreshView.startRefreshing()
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
            
            self.tableView.reloadData()
            self.refreshView.endRefreshing()
        }

    }

}
