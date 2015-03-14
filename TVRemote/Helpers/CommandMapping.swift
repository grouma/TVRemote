//
//  CommandMapping.swift
//  TVRemote
//
//  Created by Gary Roumanis on 11/16/14.
//  Copyright (c) 2014 SimplexSoftware. All rights reserved.
//

import Foundation

private let _commandMapping = CommandMapping()

class CommandMapping : NSObject {
    
    class var sharedInstance: CommandMapping {
        return _commandMapping;
    }
    
    var functionMapping : Dictionary<String,Dictionary<String,String>> =
    [
        "Insignia" :
            [
                "_TYPE"     : "NEC",
                "POWER"     : "0x61A0F00F",
                "1"         : "0x61A000FF",
                "2"         : "0x61A0807F",
                "3"         : "0x61A040BF",
                "4"         : "0x61A040BF",
                "5"         : "0x61A020DF",
                "6"         : "0x61A0A05F",
                "7"         : "0x61A0609F",
                "8"         : "0x61A0E01F",
                "9"         : "0x61A010EF",
                "0"         : "0x61A0906F",
                "VOLUP"     : "0x61A030CF",
                "VOLDOWN"   : "0x61A0B04F",
                "CHUP"      : "0x61A050AF",
                "CHDOWN"    : "0x61A0D02F",
                "INPUT"     : "0x61A0B847"
            ]
    ]
    
    func getHexCode(device: String, function : String) -> String?{
        return functionMapping[device]?[function]
    }
    
    func getProtocol(device : String) -> String?{
        return functionMapping[device]?["_TYPE"]
    }
    
}
