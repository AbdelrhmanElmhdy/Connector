//
//  UserDefaultsManager.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/07/2022.
//

import Foundation
import UIKit

class UserDefaultsManager {
    struct Keys {
        static let isLoggedIn = "IS_LOGGED_IN"
        static let currentUsername = "CURRENT_USERNAME"
    }
    
    @UserDefaultsProperty(key: Keys.isLoggedIn, defaultValue: false)
    var isLoggedIn: Bool
    
    @UserDefaultsProperty(key: Keys.currentUsername, defaultValue: "")
    var currentUsername: String
    
}
