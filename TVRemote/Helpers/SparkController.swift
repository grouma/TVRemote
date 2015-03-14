//
//  SparkController.swift
//  TVRemote
//
//  Created by Gary Roumanis on 11/13/14.
//  Copyright (c) 2014 SimplexSoftware. All rights reserved.
//

import Foundation

private let _sparkController = SparkController()

class SparkController : NSObject{
    
    var accessToken : String?
    var devices : Array<NSDictionary>?
    var activeDevice : String?
    
    let host = "https://api.spark.io"
    let session = NSURLSession.sharedSession()

    class var sharedInstance: SparkController {
        return _sparkController;
    }
    
    func login(username: String, password: String, completionHandler: (success : Bool, message: String?) -> Void){
        self.getAccessToken(username, password: password) { (success) -> Void in
            if(success){
                self.getDevices({ (success) -> Void in
                    if(success){
                        completionHandler(success: true, message: nil)
                    }else{
                        completionHandler(success: false, message: "Error pulling devices")
                    }
                })
            }else{
                completionHandler(success: false, message: "Username or password incorrect")
            }
        }
    }
    
    func getDevices(completionHandler: (success : Bool) -> Void){
        let authString = "Bearer \(self.accessToken!)"
        let url = host + "/v1/devices"
        getRequest(url, auth: authString) { (data, response, error) -> Void in
            var err: NSError?
            var parsedResponse = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? Array<NSDictionary>
            if(err == nil){
                self.devices = parsedResponse
                completionHandler(success: true)
                return
            }
            completionHandler(success: false)
        }
    }
    
    func setActiveDevice(index: Int){
        self.activeDevice = devices?[index]["id"] as String?
    }
    
    func sendFunction(function: String, args: String, completionHanlder: (success: Bool, returnValue: Int?) -> Void){
        let params = ["args" : args]
        let authString = "Bearer \(self.accessToken!)"
        let url = host + "/v1/devices/\(self.activeDevice!)/\(function)/"
        self.postRequest(params, url: url, auth: authString) { (data, response, error) -> Void in
            var err: NSError?
            var parsedResponse = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            if(err == nil){
                let responseError = parsedResponse?["error"] as String?
                if(responseError == nil){
                    let returnValue = parsedResponse?["return_value"] as Int?
                    completionHanlder(success: true, returnValue: returnValue)
                    return

                }
            }
            completionHanlder(success: false, returnValue: nil)
        }
    }
    
    private func getAccessToken(username : String, password: String, completionHanlder: (success: Bool) -> Void){
        // Spark API require HTTP Basic Auth credentials
        let authString = "spark:spark"
        let authData = authString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64EncodedCredential = authData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        let auth = NSString(string: "Basic \(base64EncodedCredential)")
        let params = ["grant_type" : "password", "username" : username, "password": password]
        self.postRequest(params, url: host + "/oauth/token", auth: auth) { (data, response, error) -> Void in
            if(error == nil){
                var err: NSError?
                var parsedResponse = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                if(err == nil){
                    let accessToken = parsedResponse?["access_token"] as String?
                    if(accessToken != nil){
                        self.accessToken = accessToken;
                        completionHanlder(success: true)
                        return
                    }
                }
            }
            completionHanlder(success: false)
        }
    }
    
    private func getRequest(url: String, auth: String, completionHandler: (NSData!, NSURLResponse!, NSError!) -> Void){
        var err: NSError?
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        // Add auth header if provided
        if(!auth.isEmpty){
            request.setValue(auth, forHTTPHeaderField: "Authorization")
        }
        var task = session.dataTaskWithRequest(request,completionHandler: completionHandler)
        task.resume()
        
    }
    
    private func postRequest(params : Dictionary<String,String>, url : String, auth : String, completionHandler : (NSData!, NSURLResponse!, NSError!) -> Void ) {
        // Form encode parameter dictionary
        var bodyData = ""
        for (parameter, value) in params {
            if (!bodyData.isEmpty){
                bodyData += "&"
            }
            bodyData += parameter + "=" + value
        }
        var err: NSError?
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        // Add auth header if provided
        if(!auth.isEmpty){
            request.setValue(auth, forHTTPHeaderField: "Authorization")
        }
        // Spark API requires urlencoded requests
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        var task = session.dataTaskWithRequest(request,completionHandler: completionHandler)
        task.resume()
    }
    
}