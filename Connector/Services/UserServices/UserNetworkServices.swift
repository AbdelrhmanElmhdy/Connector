//
//  UserServices.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 04/10/2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import CoreData

class UserNetworkServices: UserNetworkServicesProtocol {
    private let firebaseManager: FirebaseManager
    private var userSearchListener: ListenerRegistration?
    
    required init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
    }
    
    func setUserData(user: User) {
        let userDocumentRef = firebaseManager.firestoreDB.collection("users").document(user.id)
        firebaseManager.setData(on: userDocumentRef, usingObject: user)
    }
    
    func fetchUser(withId uid: String, backgroundMOC: NSManagedObjectContext, completion: @escaping (_ user: User?, _ error: Error?) -> Void) {
        let userDocumentRef = firebaseManager.firestoreDB.collection("users").document(uid)
        firebaseManager.getDocument(from: userDocumentRef, backgroundMOC: backgroundMOC, completion: completion)
    }
    
    func searchForUsers(withUsernameSimilarTo username: String, backgroundMOC: NSManagedObjectContext, handler: @escaping (_ users: [User]?, _ error: Error?) -> Void) {
        let query = firebaseManager.firestoreDB.collection("users").whereField("username", isEqualTo: username.lowercased())
        userSearchListener = firebaseManager.addListener(to: query, backgroundMOC: backgroundMOC, handler: handler)
    }
    
    func cancelUserSearch() {
        userSearchListener?.remove()
    }
}
