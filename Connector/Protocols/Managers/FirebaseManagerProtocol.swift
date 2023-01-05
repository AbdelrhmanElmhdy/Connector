//
//  FirebaseManagerProtocol.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import CoreData

protocol FirebaseManagerProtocol: AutoMockable {
	var firestoreDB: Firestore { get }
	var auth: Auth { get }
	
	func setData(on documentRef: DocumentReference, data: FirebaseData)
	
	func setData(on documentRef: DocumentReference, usingObject object: FirebaseCodableManagedObject)
	
	func updateData(on documentRef: DocumentReference, data: FirebaseData)
	
	func updateData(on documentRef: DocumentReference, usingObject object: FirebaseCodableManagedObject)
	
	func getDocument(from documentRef: DocumentReference, completion: @escaping (DocumentSnapshot?, Error?) -> Void )
	
	func getDocument<T: FirebaseCodableManagedObject>(from documentRef: DocumentReference,
																										backgroundMOC: NSManagedObjectContext,
																										completion: @escaping (T?, Error?) -> Void )
	
	func addListener(to documentRef: DocumentReference, handler: @escaping (DocumentSnapshot?, Error?) -> Void)
	
	func addListener<T: FirebaseCodableManagedObject>(to documentRef: DocumentReference,
																										backgroundMOC: NSManagedObjectContext,
																										handler: @escaping (T?, Error?) -> Void)
	
	func addListener(to query: Query, handler: @escaping (QuerySnapshot?, Error?) -> Void) -> ListenerRegistration?
	
	func addListener<T: FirebaseCodableManagedObject>(to query: Query,
																										backgroundMOC: NSManagedObjectContext,
																										handler: @escaping ([T]?, Error?) -> Void) -> ListenerRegistration?
	
	func createUser(email: String, password: String, completion: @escaping (_ userID: String?, FirebaseAuthError?) -> Void)
	
	func signIn(email: String, password: String, completion: @escaping (_ userID: String?, FirebaseAuthError?) -> Void)
	
	func signOut() throws
}
