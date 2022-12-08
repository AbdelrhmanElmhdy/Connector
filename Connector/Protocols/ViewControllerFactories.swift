//
//  ViewControllerFactories.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 26/11/2022.
//

import Foundation

protocol AuthViewControllerFactory: AnyObject {
    func createLoginViewController(for coordinator: Authenticating & CreatingAccount) -> LoginViewController
    func createSignupViewController(for coordinator: Authenticating & LoggingIn) -> SignupViewController
}

protocol ChatsViewControllerFactory: AnyObject {
    func createChatsTableViewController(for coordinator: Chatting) -> ChatsTableViewController
    func createChatRoomViewController(for coordinator: Coordinator, chatRoom: ChatRoom) -> ChatRoomViewController
}

protocol CallsTableViewControllerFactory: AnyObject {
    func createCallsTableViewController(for coordinator: Coordinator) -> CallsTableViewController
}

protocol SettingsTableViewControllerFactory: AnyObject {
    func createSettingsTableViewController(for coordinator: SettingsCoordinator, settingsSections: [SettingsSection]?) -> SettingsTableViewController
}

typealias ViewControllerFactory = AuthViewControllerFactory & ChatsViewControllerFactory & CallsTableViewControllerFactory & SettingsTableViewControllerFactory
