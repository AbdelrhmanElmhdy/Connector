//
//  MainAuthService.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 04/10/2022.
//

import Foundation
import Combine

class MainAuthService: AuthService {
	
	private let userDefaultsManager: UserDefaultsManagerProtocol
	private let keychainManager: KeychainManagerProtocol
	private let authNetworkService: AuthNetworkService
	private let coreDataManager: CoreDataManagerProtocol
	weak var userService: UserService?
	
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
	
	init(userDefaultsManager: UserDefaultsManagerProtocol,
			 keychainManager: KeychainManagerProtocol,
			 coreDataManager: CoreDataManagerProtocol,
			 authNetworkService: AuthNetworkService) {
		self.userDefaultsManager = userDefaultsManager
		self.keychainManager = keychainManager
		self.authNetworkService = authNetworkService
		self.coreDataManager = coreDataManager
	}
	
	func login(email: String, password: String) -> Future<Void, Error> {
		return Future() { promise in
			self.authNetworkService.login(email: email, password: password) { userId, error in
				if let error = error { return promise(.failure(error)) }
				
				guard let userId = userId else { return promise(.failure(FirebaseAuthError.somethingWentWrong(description: .errors.userIdUnavailable))) }
				
				guard let userService = self.userService else {
					return promise(.failure(UnwrappingError.failedToUnwrapWeakVariable(description: "userService is nil", isFatal: true)))
				}
				
				// Fetch user data from firestore.
				userService.fetchRemoteUser(withId: userId) { user, error in
					
					if let error = error { return promise(.failure(error)) }
					
					guard let user = user else { return promise(.failure(FirebaseAuthError.somethingWentWrong(description: .errors.userDataNotFound))) }
					
					self.isLoggedIn = true
					self.username = user.username
					self.userId = userId
					user.isCurrentUser = true
					
					// Save the user object.
					do { try self.coreDataManager.commitChanges(onContext: .auto) }
					catch { return promise(.failure(error)) }
					
					promise(.success(()))
				}
			}
		}
	}
	
	func signup(user: User, password: String) -> Future<Void, Error> {
		return Future() { promise in
			self.authNetworkService.signup(user: user, password: password) { userId, error in
				if let error = error { return promise(.failure(error)) }
				guard let userId = userId else { return promise(.failure(FirebaseAuthError.somethingWentWrong(description: .errors.userIdUnavailable))) }
				
				user.id = userId
				
				guard let userService = self.userService else {
					return promise(.failure(UnwrappingError.failedToUnwrapWeakVariable(description: "userService is nil", isFatal: true)))
				}
				
				// Upload user data on firestore.
				userService.setRemoteUserData(user: user)
				
				self.isLoggedIn = true
				self.username = user.username
				self.userId = userId
				user.isCurrentUser = true
				
				// Save the user object.
				do { try self.coreDataManager.commitChanges(onContext: .auto) }
				catch { return promise(.failure(error)) }
				
				promise(.success(()))
			}
		}
	}
	
	func signOut() throws {
		try authNetworkService.signOut()
		userService?.deleteUser(username: username)
		
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
