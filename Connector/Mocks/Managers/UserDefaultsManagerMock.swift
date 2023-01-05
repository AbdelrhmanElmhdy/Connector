//
//  UserDefaultsManagerMock.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import Foundation

/// Replaces user defaults persistence with in-memory persistence
class UserDefaultsManagerMock: UserDefaultsManagerProtocol {
	
	var isLoggedIn = false
	
	var currentUsername = ""
	
	var userPreferences = UserPreferences.defaultPreferences
	
}
