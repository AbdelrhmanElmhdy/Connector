//
//  AuthServicesProtocol.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 04/10/2022.
//

import Foundation
import Combine

protocol AuthServicesProtocol: AnyObject {
    var userServices: UserServicesProtocol? { get set }
    
    var isLoggedIn: Bool { get set }
    var username: String { get set }
    var userId: String { get set }
    
    init(userDefaultsManager: UserDefaultsManager,
         keychainManager: KeychainManager,
         coreDataManager: CoreDataManager,
         authNetworkServices: AuthNetworkServicesProtocol)
    
    func login(email: String, password: String) -> Future<Void, Error>
    func signup(user: User, password: String) -> Future<Void, Error>
    func signOut() throws
}
