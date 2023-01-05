//
//  AuthNetworkService.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 03/10/2022.
//

import Foundation
import FirebaseAuth
protocol AuthNetworkService: AutoMockable {  
	func login(email: String, password: String, completion: @escaping (_ userID: String?, FirebaseAuthError?) -> Void)
	func signup(user: User, password: String, completion: @escaping (_ userID: String?, FirebaseAuthError?) -> Void)
	func signOut() throws
}
