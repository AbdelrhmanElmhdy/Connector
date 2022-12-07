//
//  AuthServices.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 04/10/2022.
//

import Foundation
import Combine

class AuthServices: AuthServicesProtocol {
    
    private let userDefaultsManager: UserDefaultsManager
    private let keychainManager: KeychainManager
    private let authNetworkServices: AuthNetworkServicesProtocol
    private let coreDataManager: CoreDataManager
    weak var userServices: UserServicesProtocol?
    
    var isLoggedIn: Bool {
        get { userDefaultsManager.isLoggedIn }
        set { userDefaultsManager.isLoggedIn = newValue }
    }
    
    var username: String {
        get { userDefaultsManager.currentUsername }
        set { userDefaultsManager.currentUsername = newValue }
    }
    
    var userId: String {
        get { keychainManager.currentUserId }
        set { keychainManager.currentUserId = newValue }
    }
    
    required init(userDefaultsManager: UserDefaultsManager,
         keychainManager: KeychainManager,
         coreDataManager: CoreDataManager,
         authNetworkServices: AuthNetworkServicesProtocol) {
        self.userDefaultsManager = userDefaultsManager
        self.keychainManager = keychainManager
        self.authNetworkServices = authNetworkServices
        self.coreDataManager = coreDataManager
    }
    
    func login(email: String, password: String) -> Future<Void, Error> {
        return Future() { promise in
            self.authNetworkServices.login(email: email, password: password) { userId, error in
                if let error = error { return promise(.failure(error)) }
                
                guard let userId = userId else { return promise(.failure(NetworkError.failedToLogin)) }
                
                guard let userServices = self.userServices else {
                    return promise(.failure(UnwrappingError.failedToUnwrapWeakVariable(description: "userServices is nil", isFatal: true)))
                }
                
                // Fetch user data from firestore.
                userServices.fetchRemoteUser(withId: userId) { user, error in
                    if let error = error { return promise(.failure(error)) }

                    guard let user = user else { return promise(.failure(NetworkError.failedToLogin)) }
                    
                    
                    self.isLoggedIn = true
                    self.username = user.username
                    self.userId = userId
                    user.isCurrentUser = true
                    
                    // Save the user object.
                    do { try self.coreDataManager.commitChanges() }
                    catch { return promise(.failure(error)) }
                    
                    promise(.success(()))
                }
            }
        }
    }
    
    func signup(user: User, password: String) -> Future<Void, Error> {
        return Future() { promise in
            self.authNetworkServices.signup(user: user, password: password) { userId, error in
                if let error = error { return promise(.failure(error)) }
                guard let userId = userId else { return promise(.failure(NetworkError.failedToSignup)) }
                
                user.id = userId
                
                guard let userServices = self.userServices else {
                    return promise(.failure(UnwrappingError.failedToUnwrapWeakVariable(description: "userServices is nil", isFatal: true)))
                }
                
                // Upload user data on firestore.
                userServices.setRemoteUserData(user: user)
                                
                self.isLoggedIn = true
                self.username = user.username
                self.userId = userId
                user.isCurrentUser = true
                
                // Save the user object.
                do { try self.coreDataManager.commitChanges() }
                catch { return promise(.failure(error)) }
                
                promise(.success(()))
            }
        }
    }
    
    func signOut() throws {
        try authNetworkServices.signOut()
        userServices?.deleteCurrentUser(username: username)
        
        isLoggedIn = false
        username = ""
        userId = ""
        
        coreDataManager.dropEntity(entityName: "User")
        coreDataManager.dropEntity(entityName: "ChatRoom")
        coreDataManager.dropEntity(entityName: "Message")
        coreDataManager.dropEntity(entityName: "Location")
        coreDataManager.dropEntity(entityName: "Contact")
    }
    
}
