//
//  UserDefaultsManager.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import Foundation

protocol UserDefaultsManager: AnyObject {
    
    var isLoggedIn: Bool { get set }
    var currentUsername: String { get set }
    var userPreferences: UserPreferences { get set }
    
}
