//
//  MainUserPreferencesService.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/12/2022.
//

import UIKit

class MainUserPreferencesService: UserPreferencesService {
	let userDefaultsManager: UserDefaultsManagerProtocol
	
	var userPreferences: UserPreferences
	
	init(userDefaultsManager: UserDefaultsManagerProtocol) {
		self.userDefaultsManager = userDefaultsManager
		self.userPreferences = userDefaultsManager.userPreferences
	}
	
	func updateUserInterfaceStyle(with state: UIUserInterfaceStyle) {
		userPreferences.userInterfaceStyle = state
		saveChanges()
	}
	
	func saveChanges() {
		userDefaultsManager.userPreferences = userPreferences
	}
}
