//
//  SettingsCoordination.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 06/12/2022.
//

import Foundation

protocol LoggingOut: AnyObject {
    func logout()
}

protocol DisclosingSettings {
    func disclose(settings settingsSections: [SettingsSection], settingsTitle: String)
}
