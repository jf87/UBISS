//
//  ReputationTableViewController.swift
//  OpenTokRTC
//
//  Created by jofu on 12/06/15.
//  Copyright (c) 2015 Song Zheng. All rights reserved.
//

import Foundation
import UIKit




class ReputationTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var repTableView : UITableView = UITableView()

    
    let volunteers = ["Henri", "Mohamed", "Jonathan"]
    let points = [140, 90, 50]
    
    let textCellIdentifier = "ScoreCell"
    
    override func viewDidLoad() {
        println("table view did load")
        super.viewDidLoad()
        self.edgesForExtendedLayout=UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars=false
        self.automaticallyAdjustsScrollViewInsets=false
        repTableView.frame         =   CGRectMake(0, 50, 320, 200);
        repTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: textCellIdentifier)
        //        messTableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        repTableView.delegate = self
        repTableView.dataSource = self
        self.view.addSubview(repTableView)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return volunteers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = String(row+1)+" "+volunteers[row] + " " + String(points[row]) + " points"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        println(volunteers[row])
        if indexPath == 0 {
            
            
        }
    }

}
