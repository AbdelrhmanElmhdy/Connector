//
//  UITextsContainer.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 02/01/2023.
//

import Foundation
struct UITextsContainer {
	// MARK: Auth UI Texts
	static let username = "Username".localized
	static let email = "Email".localized
	static let password = "Password".localized
	static let login = "Login".localized
	static let logout = "Logout".localized
	
	static let notExistingUserLabel = "Not an existing user?".localized
	static let createAccountSuggestionBtnTitle = "Create an account".localized
	static let firstNameTextFieldPlaceholder = "First Name".localized
	static let lastNameTextFieldPlaceholder = "Last Name".localized
	
	static let confirmPasswordTextFieldPlaceholder = "Confirm Password".localized
	static let confirmPasswordTextFieldNounName = "Password Confirmation".localized
	static let createAccountBtnTitle = "Create Account".localized
	static let alreadyHaveAccountLabel = "Already have an account?".localized
	
	// MARK: `ChatsTableViewController` UI Texts
	static let chatsSearchBarPlaceholder = "Search Chats".localized
	
	// MARK: `CallsTableViewController` UI Texts
	static let emptyCallsTableViewMessage = "Calls you make will appear here".localized
	
	// MARK: `SettingsViewController` UI Texts
	static let general = "General".localized
	static let account = "Account".localized
	static let notifications = "Notifications".localized
	static let soundsAndHaptics = "Sounds & Haptics".localized
	
	static let darkModeOption = "Dark Mode".localized
	static let receiveNotificationsOption = "Receive notifications".localized
	
	// MARK: `ChatRoom` UI Texts
	static let defaultGroupChatName = "Group Chat".localized
	
	// MARK: `ChatRoomViewController` UI Texts
	static let message = "message".localized
	
	// MARK: `ChatsTableViewController` UI Texts
	static let emptyChatsTableViewMessage = "Your chats will appear here".localized
	
	// MARK: Generic UI Texts
	static let chats = "Chats".localized
	static let calls = "Calls".localized
	static let settings = "Settings".localized
	
	static let ok = "Ok".localized
	static let cancel = "Cancel".localized
	static let done = "Done".localized
	
	static let error = "Error".localized
	
	static let photo = "Photo".localized
	static let video = "Video".localized
	static let voiceNote = "VoiceNote".localized
	static let file = "File".localized
	static let location = "Location".localized
	static let contact = "Contact".localized
	
	static let off = "Off".localized
	static let on = "On".localized
	static let system = "System".localized
}
