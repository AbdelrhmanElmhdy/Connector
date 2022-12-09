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
        static let userPreferences = "USER_PREFERENCES"
    }
    
    @UserDefaultsProperty(key: Keys.isLoggedIn, defaultValue: false)
    var isLoggedIn: Bool
    
    @UserDefaultsProperty(key: Keys.currentUsername, defaultValue: "")
    var currentUsername: String
    
    @UserDefaultsProperty(key: Keys.userPreferences, defaultValue: UserPreferences.defaultPreferences)
    var userPreferences: UserPreferences
    
}
