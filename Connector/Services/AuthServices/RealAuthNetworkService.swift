//
//  RealAuthNetworkService.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 03/10/2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class RealAuthNetworkService: AuthNetworkService {
    
    private let firebaseManager: FirebaseManager
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
    }
    
    func login(email: String, password: String, completion: @escaping (_ userID: String?, FirebaseAuthError?) -> Void) {
        firebaseManager.signIn(email: email, password: password) { authResult, error in
            completion(authResult?.user.uid, error)
        }
    }

    func signup(user: User, password: String, completion: @escaping (_ userID: String?, FirebaseAuthError?) -> Void) {
        firebaseManager.createUser(email: user.email, password: password) { authResult, error in
            completion(authResult?.user.uid, error)
        }
    }
    
    func signOut() throws {
        try firebaseManager.signOut()
    }
}
