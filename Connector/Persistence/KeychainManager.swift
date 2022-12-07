//
//  KeychainManager.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 30/11/2022.
//

import Foundation
import SwiftKeychainWrapper

class KeychainManager {
    struct Keys {
        static let currentUserId = "CURRENT_USER_ID"
        static let accessToken = "ACCESS_TOKEN"
    }
    
    @KeychainProperty(key: Keys.currentUserId, defaultValue: "")
    var currentUserId: String
    
    @KeychainProperty(key: Keys.currentUserId, defaultValue: "")
    var accessToken: String
    
}
