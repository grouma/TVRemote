//
//  LoginViewController.swift
//  TVRemote
//
//  Created by Gary Roumanis on 10/9/14.
//  Copyright (c) 2014 SimplexSoftware. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(updateInput()){
            login(self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnToLogin(sender: UIStoryboardSegue){
        // Remove saved credentials
        usernameTextField.text = nil
        passwordTextField.text = nil
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "username")
        NSUserDefaults.standardUserDefaults().synchronize()
        KeychainService.removePassword()
    }
    
    func updateInput() -> Bool {
        // Load saved credentials
        let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as String?
        usernameTextField.text = username
        let password = KeychainService.loadPassword()
        passwordTextField.text = password
        if(username != nil && password != nil){
            return true
        }else{
            return false
        }
    }

    @IBAction func login(sender: AnyObject) {
        let sparkController = SparkController.sharedInstance
        let username = usernameTextField.text
        let password = passwordTextField.text
        sparkController.login(usernameTextField.text, password: passwordTextField.text) {(success : Bool, message: String?) -> Void in
            if(success){
                // save username and password
                NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
                NSUserDefaults.standardUserDefaults().synchronize()
                KeychainService.savePassword(password)
                // Navigate from login
                dispatch_sync(dispatch_get_main_queue()){
                    self.performSegueWithIdentifier("toDeviceListController", sender: self)
                }
            }else{
                dispatch_sync(dispatch_get_main_queue()){
                    var alert = UIAlertController(title: "Error", message: message!, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }

}

