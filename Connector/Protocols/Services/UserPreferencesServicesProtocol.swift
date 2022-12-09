//
//  UserPreferencesServicesProtocol.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/12/2022.
//

import UIKit

protocol UserPreferencesServicesProtocol {
    var userDefaultsManager: UserDefaultsManager { get }
    
    init(userDefaultsManager: UserDefaultsManager)
    
    func updateUserInterfaceStyle(with state: UIUserInterfaceStyle)
    func saveChanges()
}
