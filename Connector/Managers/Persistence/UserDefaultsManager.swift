//
//  UserDefaultsManager.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/07/2022.
//

import Foundation
import UIKit

class UserDefaultsManager: UserDefaultsManagerProtocol {
	private struct Keys {
		static let isLoggedIn = "IS_LOGGED_IN"
		static let currentUsername = "CURRENT_USERNAME"
		static let userPreferences = "USER_PREFERENCES"
	}
	
	@Storage(key: Keys.isLoggedIn, defaultValue: false)
	var isLoggedIn: Bool
	
	@Storage(key: Keys.currentUsername, defaultValue: "")
	var currentUsername: String
	
	@Storage(key: Keys.userPreferences, defaultValue: UserPreferences.defaultPreferences)
	var userPreferences: UserPreferences
	
}
