//
//  UserServices.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 26/11/2022.
//

import Foundation
import CoreData

class UserServices: UserServicesProtocol {
    
    private let coreDataManager: CoreDataManager
    private let userNetworkServices: UserNetworkServicesProtocol
    private let authServices: AuthServicesProtocol
    
    required init(coreDataManager: CoreDataManager,
                  userNetworkServices: UserNetworkServicesProtocol,
                  authServices: AuthServicesProtocol) {
        self.coreDataManager = coreDataManager
        self.userNetworkServices = userNetworkServices
        self.authServices = authServices
        
        authServices.userServices = self
    }
    
    func createUser() -> User { User(context: coreDataManager.context) }
    
    func fetchUser(withObjectID objectID: NSManagedObjectID) throws -> User? {
        return try coreDataManager.fetchManagedObject(withObjectID: objectID)
    }
    
    func fetchUsers(withObjectIDs objectIDs: [NSManagedObjectID]) -> [User]? {
        return coreDataManager.fetchManagedObjects(ofType: User.self, withObjectIDs: objectIDs)
    }
    
    func fetchUser(withId id: String) -> User? {
        return coreDataManager.fetchManagedObject(ofType: User.self, withID: id)
    }
    
    func fetchUser(withUsername username: String) -> User? {
        let predicate = NSPredicate(format: "%K == '\(username)'", #keyPath(User.username))
        return coreDataManager.fetchManagedObjects(ofType: User.self, predicate: predicate)?.first
    }
        
    func fetchRemoteUser(withId uid: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void) {
        userNetworkServices.fetchUser(withId: uid, backgroundMOC: coreDataManager.backgroundContext, completion: completion)
    }
    
    func setRemoteUserData(user: User) {
        userNetworkServices.setUserData(user: user)
    }
    
    func getCurrentUser() throws -> User {
        guard authServices.isLoggedIn else { // Not logged in
            throw InvalidAccessError.invalidAccess(description: "Attempting to access currentUser while no user is logged in", isFatal: true)
        }
        
        let username = authServices.username
        
        guard !username.isEmpty else { // username is empty
            throw MissingCriticalDataError.currentUsernameNotFound()
        }
        
        if let user = fetchUser(withUsername: username) {
            return user
        } else { // No data for current user is found
            throw MissingCriticalDataError.currentUserNotFound(description: "Unable to retrieve current user with username: \(username)")
        }
        
    }
    
    func deleteCurrentUser(username: String) {
        guard let currentUser = fetchUser(withUsername: username) else { return }
        coreDataManager.deleteManagedObject(currentUser)
    }
    
    func searchForRemoteUsers(withUsernameSimilarTo username: String, handler: @escaping (_ users: [User]?, _ error: Error?) -> Void) {
        userNetworkServices.searchForUsers(withUsernameSimilarTo: username, backgroundMOC: coreDataManager.backgroundContext, handler: handler)
    }
    
    func prepareToMoveUsersToDifferentThread(_ objects: [User]) throws -> [NSManagedObjectID] {
        try coreDataManager.prepareToMoveToDifferentThread(objects)
    }
}
