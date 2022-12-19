//
//  MainDependencyContainer.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 26/11/2022.
//

import UIKit

class MainDependencyContainer: DependencyContainer {
    
    // MARK: Managers
    
    lazy var userDefaultsManager: UserDefaultsManager = RealUserDefaultsManager()
    lazy var keychainManager: KeychainManager = RealKeychainManager()
    lazy var coreDataManager: CoreDataManager = CoreDataManagerFactory.create()
    lazy var firebaseManager: FirebaseManager = FirebaseManagerFactory.create()
    
    // MARK: Factories
    
    lazy var settingsSectionFactory = SettingsSectionsFactory(userPreferences: userDefaultsManager.userPreferences)
    
    // MARK: Services
    
    lazy var authNetworkService: AuthNetworkService = RealAuthNetworkService(firebaseManager: firebaseManager)
    
    lazy var authService: AuthService = RealAuthService(
        userDefaultsManager: userDefaultsManager,
        keychainManager: keychainManager,
        coreDataManager: coreDataManager,
        authNetworkService: authNetworkService
    )
    
    lazy var userNetworkService: UserNetworkService = RealUserNetworkService(firebaseManager: firebaseManager)
    
    lazy var userService: UserService = RealUserService(
        coreDataManager: coreDataManager,
        userNetworkService: userNetworkService,
        authService: authService
    )
    
    lazy var chatRoomService: ChatRoomService = RealChatRoomService(coreDataManager: coreDataManager)
    
    lazy var chatMessageNetworkService: ChatMessageNetworkService = RealChatMessageNetworkService(
        firebaseManager: firebaseManager
    )
    
    lazy var chatMessageService: ChatMessageService = RealChatMessageService(
        coreDataManager: coreDataManager,
        chatMessageNetworkService: chatMessageNetworkService,
        userService: userService,
        authService: authService
    )
    
    lazy var userPreferencesService: UserPreferencesService = RealUserPreferencesService(userDefaultsManager: userDefaultsManager)
}
