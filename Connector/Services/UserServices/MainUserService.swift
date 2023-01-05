//
//  MainUserService.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 26/11/2022.
//

import Foundation
import CoreData

class MainUserService: UserService {
	
	private let coreDataManager: CoreDataManagerProtocol
	private let userNetworkService: UserNetworkService
	private let authService: AuthService
	
	init(coreDataManager: CoreDataManagerProtocol,
			 userNetworkService: UserNetworkService,
			 authService: AuthService) {
		self.coreDataManager = coreDataManager
		self.userNetworkService = userNetworkService
		self.authService = authService
		
		authService.userService = self
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
		return coreDataManager.fetchManagedObjects(ofType: User.self, predicate: predicate, fetchLimit: 1)?.first
	}
	
	func fetchRemoteUser(withId uid: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void) {
		userNetworkService.fetchUser(withId: uid, backgroundMOC: coreDataManager.backgroundContext, completion: completion)
	}
	
	func setRemoteUserData(user: User) {
		userNetworkService.setUserData(user: user)
	}
	
	func getCurrentUser() throws -> User {
		guard authService.isLoggedIn else { // Not logged in
			throw InvalidAccessError.invalidAccess(description: "Attempting to access currentUser while no user is logged in", isFatal: true)
		}
		
		let username = authService.username
		
		guard !username.isEmpty else { // username is empty
			throw MissingCriticalDataError.currentUsernameNotFound()
		}
		
		if let user = fetchUser(withUsername: username) {
			return user
		} else { // No data for current user is found
			throw MissingCriticalDataError.currentUserNotFound(description: "Unable to retrieve current user with username: \(username)")
		}
		
	}
	
	func deleteUser(username: String) {
		guard let user = fetchUser(withUsername: username) else { return }
		coreDataManager.deleteManagedObject(user)
	}
	
	func searchForRemoteUsers(withUsernameSimilarTo username: String, handler: @escaping (_ users: [User]?, _ error: Error?) -> Void) {
		userNetworkService.searchForUsers(withUsernameSimilarTo: username, backgroundMOC: coreDataManager.backgroundContext, handler: handler)
	}
	
	func prepareToMoveUsersToDifferentThread(_ objects: [User]) throws -> [NSManagedObjectID] {
		try coreDataManager.prepareToMoveToDifferentThread(objects)
	}
}
