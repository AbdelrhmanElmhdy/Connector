//
//  MainAuthNetworkService.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 03/10/2022.
//

import Foundation

class MainAuthNetworkService: AuthNetworkService {
	
	private let firebaseManager: FirebaseManagerProtocol
	
	init(firebaseManager: FirebaseManagerProtocol) {
		self.firebaseManager = firebaseManager
	}
	
	func login(email: String, password: String, completion: @escaping (_ userID: String?, FirebaseAuthError?) -> Void) {
		firebaseManager.signIn(email: email, password: password) { uid, error in
			completion(uid, error)
		}
	}
	
	func signup(user: User, password: String, completion: @escaping (_ userID: String?, FirebaseAuthError?) -> Void) {
		firebaseManager.createUser(email: user.email, password: password) { uid, error in
			completion(uid, error)
		}
	}
	
	func signOut() throws {
		try firebaseManager.signOut()
	}
}
