//
//  UserPreferencesServices.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/12/2022.
//

import UIKit

class UserPreferencesServices: UserPreferencesServicesProtocol {
    let userDefaultsManager: UserDefaultsManager
    
    var userPreferences: UserPreferences
    
    required init(userDefaultsManager: UserDefaultsManager) {
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
