//
//  DependencyContainer.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 26/11/2022.
//

import Foundation

protocol DependencyContainer {
    var userDefaultsManager: UserDefaultsManager { get set }
    var keychainManager: KeychainManager { get set }
    var coreDataManager: CoreDataManager { get set }
    var firebaseManager: FirebaseManager { get set }
    
    var settingsSectionFactory: SettingsSectionsFactory { get set }
    
    var userNetworkService: UserNetworkService { get set }
    var userService: UserService { get set }
    
    var authNetworkService: AuthNetworkService { get set }
    var authService: AuthService { get set }
    
    var chatRoomService: ChatRoomService { get set }
    
    var chatMessageNetworkService: ChatMessageNetworkService { get set }
    var chatMessageService: ChatMessageService { get set }
    
    var userPreferencesService: UserPreferencesService { get set }
}
