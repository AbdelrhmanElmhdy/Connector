//
//  UserServicesProtocol.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 26/11/2022.
//

import Foundation
import CoreData

protocol UserServicesProtocol: AnyObject {
    
    init(coreDataManager: CoreDataManager,
         userNetworkServices: UserNetworkServicesProtocol,
         authServices: AuthServicesProtocol)
    
    func createUser() -> User
    func fetchUser(withObjectID objectID: NSManagedObjectID) throws -> User?
    func fetchUsers(withObjectIDs objectIDs: [NSManagedObjectID]) -> [User]?
    func fetchUser(withId id: String) -> User?
    func fetchUser(withUsername username: String) -> User?
    func fetchRemoteUser(withId uid: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void)
    func setRemoteUserData(user: User)
    func getCurrentUser() throws -> User
    func deleteCurrentUser(username: String)
    func searchForRemoteUsers(withUsernameSimilarTo username: String, handler: @escaping (_ users: [User]?, _ error: Error?) -> Void)
    
    func prepareToMoveUsersToDifferentThread(_ objects: [User]) throws -> [NSManagedObjectID]
}
