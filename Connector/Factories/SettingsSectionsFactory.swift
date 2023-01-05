//
//  SettingsSectionsFactory.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/12/2022.
//

import UIKit

struct SettingsSectionsFactory {
	
	let userPreferences: UserPreferences
	
	init(userPreferences: UserPreferences) {
		self.userPreferences = userPreferences
	}
	
	func createRootSettingsSections(forViewController targetVC: SettingsViewController) -> [SettingsSection] {
		let generalSettings = createGeneralSettingsSections(forViewController: targetVC)
		let accountSettings = createAccountSettingsSections(forViewController: targetVC)
		let notificationsSettings = createNotificationsSettingsSections(forViewController: targetVC)
		let soundsAndHapticsSettings = createSoundsAndHapticsSettingsSections(forViewController: targetVC)
		
		let generalSettingsOption = SettingsDisclosureOption(
			icon: .generalSettingsIcon,
			label: .ui.general,
			children: generalSettings
		)
		
		let accountSettingsOption = SettingsDisclosureOption(
			icon: .accountIcon,
			label: .ui.account,
			children: accountSettings
		)
		
		let notificationsSettingsOption = SettingsDisclosureOption(
			icon: .notificationsIcon,
			label: .ui.notifications,
			children: notificationsSettings
		)
		
		let soundsAndHapticsSettingsOption = SettingsDisclosureOption(
			icon: .soundsIcon,
			label: .ui.soundsAndHaptics,
			children: soundsAndHapticsSettings
		)
		
		let logoutButton = SettingsButtonOption(label: .ui.logout, style: .destructive) { [weak targetVC] in
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
	
	func createGeneralSettingsSections(forViewController targetVC: SettingsViewController) -> [SettingsSection] {
		let darkModeSettingsOptions = createDarkModeSettingsOptions(forViewController: targetVC)
		
		let darkModeSettingsOption = SettingsDisclosureOption(icon: nil, label: .ui.darkModeOption, children: darkModeSettingsOptions)
		
		return [
			SettingsSection(options: [
				.disclosure(option: darkModeSettingsOption)
			])
		]
	}
	
	/// - Stub
	func createAccountSettingsSections(forViewController targetVC: SettingsViewController) -> [SettingsSection] {
		return []
	}
	
	func createNotificationsSettingsSections(forViewController targetVC: SettingsViewController) -> [SettingsSection] {
		let receiveNotificationsSwitch = SettingsSwitchOption(
			icon: nil,
			label: .ui.receiveNotificationsOption,
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
	func createSoundsAndHapticsSettingsSections(forViewController targetVC: SettingsViewController) -> [SettingsSection] {
		return []
	}
	
	func createDarkModeSettingsOptions(forViewController targetVC: SettingsViewController) -> [SettingsSection] {
		let tapHandler: (_: Int) -> Void = {[weak targetVC] value in
			let selectedUserInterfaceStyle = UIUserInterfaceStyle.init(rawValue: value)
			targetVC?.didSelectUserInterfaceStyle(selectedUserInterfaceStyle)
		}
		
		let offValue = SettingsValueOption(label: .ui.off,
																			 value: UIUserInterfaceStyle.light.rawValue,
																			 tapHandler: tapHandler)
		
		let onValue = SettingsValueOption(label: .ui.on,
																			value: UIUserInterfaceStyle.dark.rawValue,
																			tapHandler: tapHandler)
		
		let systemValue = SettingsValueOption(label: .ui.system,
																					value: UIUserInterfaceStyle.unspecified.rawValue,
																					tapHandler: tapHandler)
		
		let darkModeOptions =  [
			SettingsSection(options: [
				.value(option: offValue),
				.value(option: onValue),
				.value(option: systemValue),
			])
		]
		
		let selectedValue = userPreferences.userInterfaceStyle.rawValue
		darkModeOptions.updateSelectedValue(selectedValue: selectedValue)
		return darkModeOptions
	}
}
