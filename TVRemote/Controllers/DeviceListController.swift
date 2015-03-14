//
//  DeviceListController.swift
//  TVRemote
//
//  Created by Gary Roumanis on 11/15/14.
//  Copyright (c) 2014 SimplexSoftware. All rights reserved.
//

import UIKit

class DeviceListController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var deviceList: UITableView!
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceList.separatorInset = UIEdgeInsetsZero
        deviceList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        deviceList.addSubview(refreshControl!)
    }
    
    @IBAction func returnToDeviceList(sender: UIStoryboardSegue){
        self.deviceList.deselectRowAtIndexPath(self.deviceList.indexPathForSelectedRow()!, animated: true)
    }
    
    func refresh(sender: AnyObject){
        var sparkController = SparkController.sharedInstance;
        sparkController.getDevices { (success) -> Void in
            self.deviceList.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if var devices = SparkController.sharedInstance.devices{
            self.deviceList.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            self.deviceList.layoutMargins = UIEdgeInsetsZero
            self.deviceList.backgroundView = nil
            return devices.count
        }else{
            // Display a message when the table is empty
            let messageLabel = UILabel(frame: CGRect(x: 0,y: 0,width: self.view.bounds.width, height: self.view.bounds.height))
            messageLabel.text = "No devices found. Pull to refresh.";
            messageLabel.textColor = UIColor.blackColor()
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignment.Center;
            messageLabel.sizeToFit()
        
            self.deviceList.backgroundView = messageLabel;
            self.deviceList.separatorStyle = UITableViewCellSeparatorStyle.None;
            return 0
        }

    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        SparkController.sharedInstance.setActiveDevice(indexPath.row)
        self.performSegueWithIdentifier("toMainViewController", sender: self)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell : UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "default")
        cell.textLabel?.text = SparkController.sharedInstance.devices?[indexPath.row]["name"] as String?
        cell.detailTextLabel?.text = SparkController.sharedInstance.devices?[indexPath.row]["id"] as String?
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }

    
}
