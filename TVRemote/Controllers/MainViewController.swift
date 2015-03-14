//
//  MainViewController.swift
//  TVRemote
//
//  Created by Gary Roumanis on 11/14/14.
//  Copyright (c) 2014 SimplexSoftware. All rights reserved.
//

import UIKit

class MainViewController : UIViewController, NumberPadDelegate {
    
    @IBOutlet weak var numberPad: NumberPad!
    
    // TODO - Make device configurable
    var device = "Insignia"
    
    @IBAction func buttonPressed(button: RoundButton) {
        sendFunction(button.id)
    }
    func reactToButtonPress(button: RoundButton) {
        sendFunction(button.id)
    }
    
    private func sendFunction(function : String){
        var args : String = CommandMapping.sharedInstance.getProtocol(device)!
        let hexCode = CommandMapping.sharedInstance.getHexCode(device,function: function)
        if (hexCode != nil){
            args += hexCode!
            SparkController.sharedInstance.sendFunction("sendIR", args: args) { (success, returnValue) -> Void in
                if(!success || returnValue != 1){
                    dispatch_sync(dispatch_get_main_queue()){
                        var alert = UIAlertController(title: "Error", message: "Unable to connect to device. Check your connection.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberPad.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}