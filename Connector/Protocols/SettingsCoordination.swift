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

protocol CustomizingGeneralSettings {
    func customizeGeneralSettings()
}

protocol CustomizingAccountSettings {
    func customizeAccountSettings()
}

protocol CustomizingNotificationsSettings {
    func customizeNotificationsSettings()
}

protocol CustomizingSoundsAndHapticsSettings {
    func customizeSoundsAndHapticsSettings()
}
