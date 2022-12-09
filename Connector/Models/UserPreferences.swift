//
//  UserPreferences.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/12/2022.
//

import Foundation
import UIKit

struct UserPreferences: Codable {
    static let defaultPreferences = UserPreferences(userInterfaceStyle: .unspecified,
                                                    pushNotificationsEnabled: true,
                                                    inAppNotificationsEnabled: true)
    
    // MARK: General Settings Preferences
    var userInterfaceStyle: UIUserInterfaceStyle
    
    // MARK: Notifications Settings Preferences
    var pushNotificationsEnabled: Bool
    var inAppNotificationsEnabled: Bool
}

extension UIUserInterfaceStyle: Codable {}
