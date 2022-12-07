//
//  FirebaseManager.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 04/10/2022.
//

import Foundation
import Combine

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import CoreData

class FirebaseManager {
    let firestoreDB: Firestore
    
    init() {
        let fireStoreSettings = FirestoreSettings()
        fireStoreSettings.dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        self.firestoreDB = Firestore.firestore()
        self.firestoreDB.settings = fireStoreSettings
    }
    
    func setData(on documentRef: DocumentReference, data: FirebaseData) {
        documentRef.setData(data)
    }
    
    func setData(on documentRef: DocumentReference, usingObject object: FirebaseCodableMo) {
        documentRef.setData(object.encodeToFirebaseData())
    }
    
    func updateData(on documentRef: DocumentReference, data: FirebaseData) {
        documentRef.updateData(data)
    }
    
    func updateData(on documentRef: DocumentReference, usingObject object: FirebaseCodableMo) {
        documentRef.updateData(object.encodeToFirebaseData())
    }
    
    func getDocument(from documentRef: DocumentReference, completion: @escaping (DocumentSnapshot?, Error?) -> Void ) {
        documentRef.getDocument(completion: completion)
    }
    
    func getDocument<T: FirebaseCodableMo>(from documentRef: DocumentReference,
                                           backgroundMOC: NSManagedObjectContext,
                                           completion: @escaping (T?, Error?) -> Void ) {
        getDocument(from: documentRef) { snapshot, error in
            let decodedObject = T(document: snapshot, context: backgroundMOC)
            completion(decodedObject, error)
        }
    }
    
    func addListener(to documentRef: DocumentReference, handler: @escaping (DocumentSnapshot?, Error?) -> Void) {
        documentRef.addSnapshotListener(handler)
    }
    
    func addListener<T: FirebaseCodableMo>(to documentRef: DocumentReference,
                                           backgroundMOC: NSManagedObjectContext,
                                           handler: @escaping (T?, Error?) -> Void) {
        addListener(to: documentRef) { snapshot, error in
            let decodedObject = T(document: snapshot, context: backgroundMOC)
            handler(decodedObject, error)
        }
    }
    
    func addListener(to query: Query, handler: @escaping (QuerySnapshot?, Error?) -> Void) -> ListenerRegistration {
        return query.addSnapshotListener(handler)
    }
    
    func addListener<T: FirebaseCodableMo>(to query: Query,
                                           backgroundMOC: NSManagedObjectContext,
                                           handler: @escaping ([T]?, Error?) -> Void) -> ListenerRegistration {
        return addListener(to: query) { snapshot, error in
            guard let documents = snapshot?.documents else {
                handler(nil, error)
                return
            }

            let decodedObjects = documents
                .map { T(document: $0, context: backgroundMOC) }
                .compactMap { $0 }
            handler(decodedObjects, error)
        }
    }
    
    func createUser(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func signIn(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
