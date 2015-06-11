//
//  TableViewController.swift
//  ubiss-ios
//
//  Created by jofu on 10/06/15.
//  Copyright (c) 2015 ITU. All rights reserved.
//

import Foundation
import UIKit


class MessagesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //@IBOutlet var tableView: UITableView!

    @IBOutlet var messTableView: UITableView!
    let messages = ["Hi! Could you bring me a box of milk from the grocery store at the corner?", "Hejsa!", "Do you want to come by for a coffee later today?"]

    let messageCellIdentifier = "MessageCell"
    
    override func viewDidLoad() {
        println("table view did load")
        super.viewDidLoad()
        self.edgesForExtendedLayout=UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars=false
        self.automaticallyAdjustsScrollViewInsets=false
        //move tableview under statusbar hack
        self.messTableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        messTableView.delegate = self
        messTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(messageCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = String(row+1)+" "+messages[row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        println(messages[row])
        if indexPath == 0 {
            
            
        }
    }
    
}