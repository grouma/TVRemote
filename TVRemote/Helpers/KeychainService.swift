//
//  KeychainService.swift
//  TVRemote
//
//  Created by Gary Roumanis on 11/15/14.
//  Copyright (c) 2014 SimplexSoftware. All rights reserved.
//

import Foundation
import Security


let serviceIdentifier : String = "TVRemoteService"

class KeychainService : NSObject {
    
    class func savePassword(password: String){
        
        var dataFromString: NSData = password.dataUsingEncoding(NSUTF8StringEncoding)!
        
        self.removePassword()
        
        var keychainQuery : [String: AnyObject] = [
            kSecClass       : kSecClassGenericPassword,
            kSecAttrService : serviceIdentifier,
            kSecValueData   : dataFromString]
        var status: OSStatus = SecItemAdd(keychainQuery as CFDictionaryRef, nil)
    }
    
    class func loadPassword() -> String? {
        
        var keychainQuery : [String : AnyObject] = [
            kSecClass       : kSecClassGenericPassword,
            kSecAttrService : serviceIdentifier,
            kSecReturnData  : kCFBooleanTrue,
            kSecMatchLimit  : kSecMatchLimitOne];
        
        var dataTypeRef :Unmanaged<AnyObject>?;
        
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef);
        let opaque = dataTypeRef?.toOpaque();
        var password: String?;
        
        if let op = opaque? {
            let retrievedData = Unmanaged<NSData>.fromOpaque(op).takeUnretainedValue();
            password = NSString(data: retrievedData, encoding: NSUTF8StringEncoding);
        }
        
        return password;
    }
    
    class func removePassword() {
        var keychainQuery : [String: AnyObject] = [
            kSecClass       : kSecClassGenericPassword,
            kSecAttrService : serviceIdentifier]
        SecItemDelete(keychainQuery as CFDictionaryRef)
    }
    
}

