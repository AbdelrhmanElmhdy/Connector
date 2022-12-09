//
//  SettingsSectionsFactory.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/12/2022.
//

import UIKit

struct SettingsSectionsFactory {
    
    let userDefaultsManager: UserDefaultsManager
    
    init(userDefaultsManager: UserDefaultsManager) {
        self.userDefaultsManager = userDefaultsManager
    }
    
    func createRootSettingsSections(forTargetVC targetVC: SettingsViewController) -> [SettingsSection] {
        let generalSettings = createGeneralSettingsSections(forTargetVC: targetVC)
        let accountSettings = createAccountSettingsSections(forTargetVC: targetVC)
        let notificationsSettings = createNotificationsSettingsSections(forTargetVC: targetVC)
        let soundsAndHapticsSettings = createSoundsAndHapticsSettingsSections(forTargetVC: targetVC)
        
        let generalSettingsOption = SettingsDisclosureOption(
            icon: UIImage(named: "GeneralSettingsIcon"),
            label: "General".localized,
            children: generalSettings
        )
        
        let accountSettingsOption = SettingsDisclosureOption(
            icon: UIImage(named: "AccountIcon"),
            label: "Account".localized,
            children: accountSettings
        )
        
        let notificationsSettingsOption = SettingsDisclosureOption(
            icon: UIImage(named: "NotificationsIcon"),
            label: "Notifications".localized,
            children: notificationsSettings
        )
        
        let soundsAndHapticsSettingsOption = SettingsDisclosureOption(
            icon: UIImage(named: "SoundsIcon"),
            label: "Sounds & Haptics".localized,
            children: soundsAndHapticsSettings
        )
        
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
    func createGeneralSettingsSections(forTargetVC targetVC: SettingsViewController) -> [SettingsSection] {
        let darkModeSettingsOptions = createDarkModeSettingsOptions(forTargetVC: targetVC)
        
        let darkModeSettingsOption = SettingsDisclosureOption(icon: nil, label: "Dark Mode".localized, children: darkModeSettingsOptions)
        
        return [
            SettingsSection(options: [
                .disclosure(option: darkModeSettingsOption)
            ])
        ]
    }
    
    /// - Stub
    func createAccountSettingsSections(forTargetVC targetVC: SettingsViewController) -> [SettingsSection] {
        return []
    }
    
    /// - Stub
    func createNotificationsSettingsSections(forTargetVC targetVC: SettingsViewController) -> [SettingsSection] {
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
    func createSoundsAndHapticsSettingsSections(forTargetVC targetVC: SettingsViewController) -> [SettingsSection] {
        return []
    }
    
    func createDarkModeSettingsOptions(forTargetVC targetVC: SettingsViewController) -> [SettingsSection] {
        let tapHandler: (_: Int) -> Void = {[weak targetVC] value in
            let selectedUserInterfaceStyle = UIUserInterfaceStyle.init(rawValue: value)
            targetVC?.didSelectUserInterfaceStyle(selectedUserInterfaceStyle)
        }
        
        let offValue = SettingsValueOption(label: "Off".localized,
                                           value: UIUserInterfaceStyle.light.rawValue,
                                           tapHandler: tapHandler)
                
        let onValue = SettingsValueOption(label: "On".localized,
                                          value: UIUserInterfaceStyle.dark.rawValue,
                                          tapHandler: tapHandler)
        
        let systemValue = SettingsValueOption(label: "System".localized,
                                              value: UIUserInterfaceStyle.unspecified.rawValue,
                                              tapHandler: tapHandler)
        
        let darkModeOptions =  [
            SettingsSection(options: [
                .value(option: offValue),
                .value(option: onValue),
                .value(option: systemValue),
            ])
        ]
        
        let selectedValue = userDefaultsManager.userPreferences.userInterfaceStyle.rawValue
        darkModeOptions.updateSelectedValue(selectedValue: selectedValue)
        return darkModeOptions
    }
}
