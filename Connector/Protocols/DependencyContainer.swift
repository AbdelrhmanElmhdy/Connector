//
//  DependencyContainer.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 26/11/2022.
//

import Foundation

protocol DependencyContainer {
  var userDefaultsManager: UserDefaultsManagerProtocol { get set }
  var keychainManager: KeychainManagerProtocol { get set }
  var coreDataManager: CoreDataManagerProtocol { get set }
  var firebaseManager: FirebaseManagerProtocol { get set }
  
  var userNetworkService: UserNetworkService { get set }
  var userService: UserService { get set }
  
  var authNetworkService: AuthNetworkService { get set }
  var authService: AuthService { get set }
  
  var chatRoomService: ChatRoomService { get set }
  
  var chatMessageNetworkService: ChatMessageNetworkService { get set }
  var chatMessageService: ChatMessageService { get set }
  
  var userPreferencesService: UserPreferencesService { get set }
}
