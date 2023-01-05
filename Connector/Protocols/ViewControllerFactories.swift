//
//  ViewControllerFactories.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 26/11/2022.
//

import Foundation

protocol AuthViewControllersFactory: AnyObject {
	func createLoginViewController(for coordinator: Authenticating & CreatingAccount) -> LoginViewController
	func createSignupViewController(for coordinator: Authenticating & LoggingIn) -> SignupViewController
}

protocol ChatViewControllersFactory: AnyObject {
	func createChatsTableViewController(for coordinator: Chatting) -> ChatsTableViewController
	func createChatRoomViewController(for coordinator: Coordinator, chatRoom: ChatRoom) -> ChatRoomViewController
}

protocol CallViewControllersFactory: AnyObject {
	func createCallsTableViewController(for coordinator: Coordinator) -> CallsTableViewController
}

protocol SettingsViewControllersFactory: AnyObject {
	func createSettingsTableViewController(for coordinator: LoggingOut & DisclosingSettings,
																				 settingsSections: [SettingsSection]?) -> SettingsTableViewController
}

typealias ViewControllerFactory = AuthViewControllersFactory & ChatViewControllersFactory & CallViewControllersFactory & SettingsViewControllersFactory
