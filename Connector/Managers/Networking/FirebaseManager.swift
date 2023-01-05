//
//  FirebaseManager.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 04/10/2022.
//

import Foundation
import Combine

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import CoreData

class FirebaseManager: FirebaseManagerProtocol {
	
	var firestoreDB: Firestore { _firestoreDB }
	private var _firestoreDB: Firestore
	
	var auth: Auth { _auth }
	private let _auth: Auth
	
	init() {
		let fireStoreSettings = FirestoreSettings()
		fireStoreSettings.dispatchQueue = DispatchQueue.global(qos: .userInitiated)
		fireStoreSettings.isSSLEnabled = true
		self._firestoreDB = Firestore.firestore()
		self._firestoreDB.settings = fireStoreSettings
		
		let auth = Auth.auth()
		self._auth = auth
	}
	
	/// Initializes a `FirebaseManager` instance that's configured to use the locally hosted emulator with the specified firestore and auth ports.
	/// - Note Use only during development.
	/// - Note The emulator configuration will not be applied if the app is not running in debug mode.
	/// - Parameters:
	///   - fireStorePort: The port on which the firestore emulator is hosted.
	///   - authPort: The port on which the auth emulator is hosted.
	convenience init(fireStorePort: Int, authPort: Int) {
		self.init()
#if DEBUG
		let fireStoreSettings = FirestoreSettings()
		fireStoreSettings.dispatchQueue = DispatchQueue.global(qos: .userInitiated)
		fireStoreSettings.host = "localhost:\(fireStorePort)"
		fireStoreSettings.isSSLEnabled = false
		fireStoreSettings.isPersistenceEnabled = false
		
		self._firestoreDB = Firestore.firestore()
		self._firestoreDB.settings = fireStoreSettings
		
		self._auth.useEmulator(withHost: "localhost", port: authPort)
#endif
	}
	
	func setData(on documentRef: DocumentReference, data: FirebaseData) {
		documentRef.setData(data)
	}
	
	func setData(on documentRef: DocumentReference, usingObject object: FirebaseCodableManagedObject) {
		documentRef.setData(object.encodeToFirebaseData())
	}
	
	func updateData(on documentRef: DocumentReference, data: FirebaseData) {
		documentRef.updateData(data)
	}
	
	func updateData(on documentRef: DocumentReference, usingObject object: FirebaseCodableManagedObject) {
		documentRef.updateData(object.encodeToFirebaseData())
	}
	
	func getDocument(from documentRef: DocumentReference, completion: @escaping (DocumentSnapshot?, Error?) -> Void ) {
		documentRef.getDocument(completion: completion)
	}
	
	func getDocument<T: FirebaseCodableManagedObject>(from documentRef: DocumentReference,
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
	
	func addListener<T: FirebaseCodableManagedObject>(to documentRef: DocumentReference,
																										backgroundMOC: NSManagedObjectContext,
																										handler: @escaping (T?, Error?) -> Void) {
		addListener(to: documentRef) { snapshot, error in
			let decodedObject = T(document: snapshot, context: backgroundMOC)
			handler(decodedObject, error)
		}
	}
	
	func addListener(to query: Query, handler: @escaping (QuerySnapshot?, Error?) -> Void) -> ListenerRegistration? {
		return query.addSnapshotListener(handler)
	}
	
	func addListener<T: FirebaseCodableManagedObject>(to query: Query,
																										backgroundMOC: NSManagedObjectContext,
																										handler: @escaping ([T]?, Error?) -> Void) -> ListenerRegistration? {
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
	
	func createUser(email: String, password: String, completion: @escaping (_ userID: String?, FirebaseAuthError?) -> Void) {
		auth.createUser(withEmail: email, password: password) { completion($0?.user.uid, FirebaseAuthError($1)) }
	}
	
	func signIn(email: String, password: String, completion: @escaping (_ userID: String?, FirebaseAuthError?) -> Void) {
		auth.signIn(withEmail: email, password: password) { completion($0?.user.uid, FirebaseAuthError($1)) }
	}
	
	func signOut() throws {
		try auth.signOut()
	}
	
	func sendPasswordResetEmail(to email: String, completion: @escaping (_ error: Error?) -> Void) {
		auth.sendPasswordReset(withEmail: email, completion: completion)
	}
}
