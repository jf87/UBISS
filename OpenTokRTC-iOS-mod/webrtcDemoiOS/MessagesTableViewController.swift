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
    
    var messTableView : UITableView = UITableView()
    
    let messages = ["Hi! Could you bring me a box of milk from the grocery store at the corner?", "Hejsa!", "Do you want to come by for a coffee later today?"]
    
    let messageCellIdentifier = "MessageCell"
    
    override func viewDidLoad() {
        println("table view did load")
        super.viewDidLoad()
        self.edgesForExtendedLayout=UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars=false
        self.automaticallyAdjustsScrollViewInsets=false
        //move tableview under statusbar hack
        messTableView.frame         =   CGRectMake(0, 50, 320, 200);
        messTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: messageCellIdentifier)
//        messTableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        messTableView.delegate = self
        messTableView.dataSource = self
        self.view.addSubview(messTableView)

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
        showAlertWithText(header: "Request", message: messages[row])
        if indexPath == 0 {
            
        }
    }
    var okAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default) {
        UIAlertAction in
        println("OK Pressed")

    }

    // Show alert
    func showAlertWithText (header : String = "Request", message : String) {
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: "changetoWebrtc"))
        alert.addAction(okAction)
        alert.addAction(UIAlertAction(title: "Reject", style: UIAlertActionStyle.Default, handler: nil))
        alert.view.tintColor = UIColor.redColor()
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    

    
}