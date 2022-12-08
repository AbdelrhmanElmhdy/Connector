//
//  SettingsSectionsFactory.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/12/2022.
//

import UIKit

struct SettingsSectionsFactory {
    
    static func createRootSettingsSections(forTargetVC targetVC: SettingsViewController) -> [SettingsSection] {
        let generalSettings = createGeneralSettingsSections(forTargetVC: targetVC)
        let accountSettings = createAccountSettingsSections(forTargetVC: targetVC)
        let notificationsSettings = createNotificationsSettingsSections(forTargetVC: targetVC)
        let soundsAndHapticsSettings = createSoundsAndHapticsSettingsSections(forTargetVC: targetVC)
        
        let generalSettingsOption = SettingsDisclosureOption(icon: UIImage(named: "GeneralSettingsIcon"),
                                                             label: "General".localized,
                                                             children: generalSettings)
        
        let accountSettingsOption = SettingsDisclosureOption(icon: UIImage(named: "AccountIcon"),
                                                             label: "Account".localized,
                                                             children: accountSettings)
        
        let notificationsSettingsOption = SettingsDisclosureOption(icon: UIImage(named: "NotificationsIcon"),
                                                             label: "Notifications".localized,
                                                             children: notificationsSettings)
        
        let soundsAndHapticsSettingsOption = SettingsDisclosureOption(icon: UIImage(named: "SoundsIcon"),
                                                                      label: "Sounds & Haptics".localized,
                                                                      children: soundsAndHapticsSettings)
        
        let logoutButton = SettingsButtonOption(label: "Logout".localized, style: .destructive) { [weak targetVC] in
            targetVC?.didPressLogout()
        }
        
        return [
            SettingsSection(options: [
                .disclosure(option: generalSettingsOption),
                .disclosure(option: accountSettingsOption),
                .disclosure(option: notificationsSettingsOption),
                .disclosure(option: soundsAndHapticsSettingsOption)
            ]),
            
            SettingsSection(options: [
                .button(option: logoutButton)
            ]),
        ]
    }
    
    /// - Stub
    static func createGeneralSettingsSections(forTargetVC targetVC: SettingsViewController) -> [SettingsSection] {
        return []
    }
    
    /// - Stub
    static func createAccountSettingsSections(forTargetVC targetVC: SettingsViewController) -> [SettingsSection] {
        return []
    }
    
    /// - Stub
    static func createNotificationsSettingsSections(forTargetVC targetVC: SettingsViewController) -> [SettingsSection] {
        let receiveNotificationsSwitch = SettingsSwitchOption(
            icon: nil,
            label: "Receive notifications",
            toggleHandler: #selector(targetVC.didToggleReceiveNotificationsSwitch),
            toggleHandlerTarget: targetVC
        )
        
        return [
            SettingsSection(options: [
                .switch(option: receiveNotificationsSwitch)
            ]),
        ]
    }
    
    /// - Stub
    static func createSoundsAndHapticsSettingsSections(forTargetVC targetVC: SettingsViewController) -> [SettingsSection] {
        return []
    }
    
    
}
