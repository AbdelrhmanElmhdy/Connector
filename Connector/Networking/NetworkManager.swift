//
//  NetworkManager.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 17/04/2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct NetworkManager {
    static func listenForIncomingMessages(completionHandler: @escaping (_ message: [Message]) -> Void) {
        guard let myUid = UserDefaultsManager.user?.id else { return }
        
        Firestore.firestore()
            .collection("messages")
            .whereField("pendingFor", arrayContains: myUid)
            .addSnapshotListener { querySnapshot, error in
                // Ignore update if it's initiated from the local client.
                let updateIsLocallyInitiated = querySnapshot?.metadata.hasPendingWrites ?? false
                guard !updateIsLocallyInitiated else { return }
                
                
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                
                removeCurrentUidFromListOfMessageReceivers(documents: documents)
                
                let messages = documents.map { Message(context: CoreDataManager.context, document: $0) }
                
                completionHandler(messages)
            }
    }
    
    static func removeCurrentUidFromListOfMessageReceivers(documents: [DocumentSnapshot]) {
        for document in documents {
            guard let data = document.data() else { continue }
            let messageIsPendingFor = (data["pendingFor"] as? [String])?.filter { $0 != UserDefaultsManager.user?.id }
            document.reference.updateData(["pendingFor": messageIsPendingFor ?? []])
        }
        
    }
    
    static func initializeChatRoom(_ room: ChatRoom, withMessage message: Message) {
        Firestore.firestore().collection("chatRooms").document(room.id!).setData([
            "participantsIDs": room.participantsIDs!,
        ])
        
        sendMessage(message: message)
    }
    
    static func sendMessage(message: Message) {
        let messageDictionary = message.encodeToDictionary() as [String : Any]
        
        Firestore.firestore()
            .collection("messages")
            .document(message.id!)
            .setData(messageDictionary)
    }
    
    
    
    static func signup(firstName: String,
                       lastName: String,
                       username: String,
                       email: String,
                       password: String,
                       completion: @escaping(_ user: User?, _ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            // Handle errors.
            if let error = error {
                ErrorManager.reportError(error)
                completion(nil, error)
                return
            }
            
            guard let authResult = authResult else {
                let error = NetworkError.failedToSignup
                ErrorManager.reportError(error)
                
                completion(nil, error)
                return
            }
            
            // Create user.
            let user = User(context: CoreDataManager.context)
            user.id = authResult.user.uid
            user.firstName = firstName
            user.lastName = lastName
            user.username = username
            user.email = email
            
            // Upload user data on firestore
            uploadUserData(user: user)
            
            completion(user, nil)
        }
        
    }
        
    static func login(email: String,
                      password: String,
                      completion: @escaping(_ user: User?, _ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            // Handle error.
            if let error = error {
                ErrorManager.reportError(error)
                completion(nil, error)
                return
            }
            
            guard let authResult = authResult else {
                let error = NetworkError.failedToLogin
                ErrorManager.reportError(error)
                
                completion(nil, error)
                return
            }
            
            // Fetch user data from firestore.
            fetchUser(withId: authResult.user.uid) { user, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                completion(user, nil)
            }
            
        }
    }
    
    static func fetchUser(withId uid: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void) {
        Firestore.firestore().collection("users").document(uid).getDocument { document, error in
            guard let document = document else {
                completion(nil, error)
                return
            }
            
            let user = User(context: CoreDataManager.context, document: document)
            
            completion(user, nil)
        }
    }
    
    static func searchUsersByUserName(username: String, completion: @escaping (_ users: [User]?, _ error: Error?) -> Void) {
        Firestore.firestore()
            .collection("users")
            .whereField("username", isEqualTo: username)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    completion(nil, error)
                    return
                }
                
                let users: [User] = documents.map { document in
                    let userData = document.data()
                    
                    let user = User(context: CoreDataManager.context)
                    user.id = document.documentID
                    user.firstName = userData["firstName"] as? String
                    user.lastName = userData["lastName"] as? String
                    user.username = userData["username"] as? String
                    user.email = userData["email"] as? String
                    
                    return user
                }
                
                completion(users, nil)
            }
    }
    
    static func uploadUserData(user: User) {
        guard let uid = user.id,
              let firstName = user.firstName,
              let lastName = user.lastName,
              let username = user.username,
              let email = user.email else { return }
        
        Firestore.firestore().collection("users").document(uid).setData([
            "firstName": firstName,
            "lastName": lastName,
            "username": username,
            "email": email,
        ])
    }
    
}
