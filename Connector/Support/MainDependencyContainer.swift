//
//  MainDependencyContainer.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 26/11/2022.
//

import UIKit

class MainDependencyContainer: DependencyContainer {
	
	// MARK: Managers
	
	lazy var userDefaultsManager = UserDefaultsManagerFactory.make()
	lazy var keychainManager = KeychainManagerFactory.make()
	lazy var coreDataManager = CoreDataManagerFactory.make()
	lazy var firebaseManager = FirebaseManagerFactory.make()
	
	// MARK: Services
	
	lazy var authNetworkService: AuthNetworkService = MainAuthNetworkService(firebaseManager: firebaseManager)
	
	lazy var authService: AuthService = MainAuthService(
		userDefaultsManager: userDefaultsManager,
		keychainManager: keychainManager,
		coreDataManager: coreDataManager,
		authNetworkService: authNetworkService
	)
	
	lazy var userNetworkService: UserNetworkService = MainUserNetworkService(firebaseManager: firebaseManager)
	
	lazy var userService: UserService = MainUserService(
		coreDataManager: coreDataManager,
		userNetworkService: userNetworkService,
		authService: authService
	)
	
	lazy var chatRoomService: ChatRoomService = MainChatRoomService(coreDataManager: coreDataManager)
	
	lazy var chatMessageNetworkService: ChatMessageNetworkService = MainChatMessageNetworkService(
		firebaseManager: firebaseManager
	)
	
	lazy var chatMessageService: ChatMessageService = MainChatMessageService(
		coreDataManager: coreDataManager,
		chatMessageNetworkService: chatMessageNetworkService,
		userService: userService,
		authService: authService
	)
	
	lazy var userPreferencesService: UserPreferencesService = MainUserPreferencesService(userDefaultsManager: userDefaultsManager)
}
