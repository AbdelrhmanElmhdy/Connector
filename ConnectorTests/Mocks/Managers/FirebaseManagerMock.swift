// Generated using Sourcery 1.9.2 — https://github.com/krzysztofzablocki/Sourcery

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import CoreData
@testable import Connector

class FirebaseManagerMock: FirebaseManagerProtocol {

  var firestoreDB: Firestore {
      get { return underlyingFirestoreDB }
      set(value) { underlyingFirestoreDB = value }
  }
  var underlyingFirestoreDB: Firestore!
  var auth: Auth {
      get { return underlyingAuth }
      set(value) { underlyingAuth = value }
  }
  var underlyingAuth: Auth!

  //MARK: - setData

  var setDataOnDataCallsCount = 0
  var setDataOnDataCalled: Bool {
      return setDataOnDataCallsCount > 0
  }
  var setDataOnDataReceivedArguments: (documentRef: DocumentReference, data: FirebaseData)?
  var setDataOnDataReceivedInvocations: [(documentRef: DocumentReference, data: FirebaseData)] = []
  var setDataOnDataClosure: ((DocumentReference, FirebaseData) -> Void)?

  func setData(on documentRef: DocumentReference, data: FirebaseData) {
      setDataOnDataCallsCount += 1
      setDataOnDataReceivedArguments = (documentRef: documentRef, data: data)
      setDataOnDataReceivedInvocations.append((documentRef: documentRef, data: data))
      setDataOnDataClosure?(documentRef, data)
  }

  //MARK: - setData

  var setDataOnUsingObjectCallsCount = 0
  var setDataOnUsingObjectCalled: Bool {
      return setDataOnUsingObjectCallsCount > 0
  }
  var setDataOnUsingObjectReceivedArguments: (documentRef: DocumentReference, object: FirebaseCodableManagedObject)?
  var setDataOnUsingObjectReceivedInvocations: [(documentRef: DocumentReference, object: FirebaseCodableManagedObject)] = []
  var setDataOnUsingObjectClosure: ((DocumentReference, FirebaseCodableManagedObject) -> Void)?

  func setData(on documentRef: DocumentReference, usingObject object: FirebaseCodableManagedObject) {
      setDataOnUsingObjectCallsCount += 1
      setDataOnUsingObjectReceivedArguments = (documentRef: documentRef, object: object)
      setDataOnUsingObjectReceivedInvocations.append((documentRef: documentRef, object: object))
      setDataOnUsingObjectClosure?(documentRef, object)
  }

  //MARK: - updateData

  var updateDataOnDataCallsCount = 0
  var updateDataOnDataCalled: Bool {
      return updateDataOnDataCallsCount > 0
  }
  var updateDataOnDataReceivedArguments: (documentRef: DocumentReference, data: FirebaseData)?
  var updateDataOnDataReceivedInvocations: [(documentRef: DocumentReference, data: FirebaseData)] = []
  var updateDataOnDataClosure: ((DocumentReference, FirebaseData) -> Void)?

  func updateData(on documentRef: DocumentReference, data: FirebaseData) {
      updateDataOnDataCallsCount += 1
      updateDataOnDataReceivedArguments = (documentRef: documentRef, data: data)
      updateDataOnDataReceivedInvocations.append((documentRef: documentRef, data: data))
      updateDataOnDataClosure?(documentRef, data)
  }

  //MARK: - updateData

  var updateDataOnUsingObjectCallsCount = 0
  var updateDataOnUsingObjectCalled: Bool {
      return updateDataOnUsingObjectCallsCount > 0
  }
  var updateDataOnUsingObjectReceivedArguments: (documentRef: DocumentReference, object: FirebaseCodableManagedObject)?
  var updateDataOnUsingObjectReceivedInvocations: [(documentRef: DocumentReference, object: FirebaseCodableManagedObject)] = []
  var updateDataOnUsingObjectClosure: ((DocumentReference, FirebaseCodableManagedObject) -> Void)?

  func updateData(on documentRef: DocumentReference, usingObject object: FirebaseCodableManagedObject) {
      updateDataOnUsingObjectCallsCount += 1
      updateDataOnUsingObjectReceivedArguments = (documentRef: documentRef, object: object)
      updateDataOnUsingObjectReceivedInvocations.append((documentRef: documentRef, object: object))
      updateDataOnUsingObjectClosure?(documentRef, object)
  }

  //MARK: - getDocument

  var getDocumentFromCompletionCallsCount = 0
  var getDocumentFromCompletionCalled: Bool {
      return getDocumentFromCompletionCallsCount > 0
  }
  var getDocumentFromCompletionReceivedArguments: (documentRef: DocumentReference, completion: (DocumentSnapshot?, Error?) -> Void)?
  var getDocumentFromCompletionReceivedInvocations: [(documentRef: DocumentReference, completion: (DocumentSnapshot?, Error?) -> Void)] = []
  var getDocumentFromCompletionClosure: ((DocumentReference, @escaping (DocumentSnapshot?, Error?) -> Void) -> Void)?

  func getDocument(from documentRef: DocumentReference, completion: @escaping (DocumentSnapshot?, Error?) -> Void) {
      getDocumentFromCompletionCallsCount += 1
      getDocumentFromCompletionReceivedArguments = (documentRef: documentRef, completion: completion)
      getDocumentFromCompletionReceivedInvocations.append((documentRef: documentRef, completion: completion))
      getDocumentFromCompletionClosure?(documentRef, completion)
  }

  //MARK: - getDocument<T: FirebaseCodableManagedObject>

  var getDocumentFromBackgroundMOCCompletionCallsCount = 0
  var getDocumentFromBackgroundMOCCompletionCalled: Bool {
      return getDocumentFromBackgroundMOCCompletionCallsCount > 0
  }
  var getDocumentFromBackgroundMOCCompletionReceivedArguments: (documentRef: DocumentReference, backgroundMOC: NSManagedObjectContext, completion: Any)?
  var getDocumentFromBackgroundMOCCompletionReceivedInvocations: [(documentRef: DocumentReference, backgroundMOC: NSManagedObjectContext, completion: Any)] = []
  var getDocumentFromBackgroundMOCCompletionClosure: ((DocumentReference, NSManagedObjectContext, Any) -> Void)?

  func getDocument<T: FirebaseCodableManagedObject>(from documentRef: DocumentReference, backgroundMOC: NSManagedObjectContext, completion: @escaping (T?, Error?) -> Void) {
      getDocumentFromBackgroundMOCCompletionCallsCount += 1
      getDocumentFromBackgroundMOCCompletionReceivedArguments = (documentRef: documentRef, backgroundMOC: backgroundMOC, completion: completion)
      getDocumentFromBackgroundMOCCompletionReceivedInvocations.append((documentRef: documentRef, backgroundMOC: backgroundMOC, completion: completion))
      getDocumentFromBackgroundMOCCompletionClosure?(documentRef, backgroundMOC, completion)
  }

  //MARK: - addListener

  var addListenerToHandlerCallsCount = 0
  var addListenerToHandlerCalled: Bool {
      return addListenerToHandlerCallsCount > 0
  }
  var addListenerToHandlerReceivedArguments: (documentRef: DocumentReference, handler: (DocumentSnapshot?, Error?) -> Void)?
  var addListenerToHandlerReceivedInvocations: [(documentRef: DocumentReference, handler: (DocumentSnapshot?, Error?) -> Void)] = []
  var addListenerToHandlerClosure: ((DocumentReference, @escaping (DocumentSnapshot?, Error?) -> Void) -> Void)?

  func addListener(to documentRef: DocumentReference, handler: @escaping (DocumentSnapshot?, Error?) -> Void) {
      addListenerToHandlerCallsCount += 1
      addListenerToHandlerReceivedArguments = (documentRef: documentRef, handler: handler)
      addListenerToHandlerReceivedInvocations.append((documentRef: documentRef, handler: handler))
      addListenerToHandlerClosure?(documentRef, handler)
  }

  //MARK: - addListener<T: FirebaseCodableManagedObject>

  var addListenerToBackgroundMOCHandlerCallsCount = 0
  var addListenerToBackgroundMOCHandlerCalled: Bool {
      return addListenerToBackgroundMOCHandlerCallsCount > 0
  }
  var addListenerToBackgroundMOCHandlerReceivedArguments: (documentRef: DocumentReference, backgroundMOC: NSManagedObjectContext, handler: Any)?
  var addListenerToBackgroundMOCHandlerReceivedInvocations: [(documentRef: DocumentReference, backgroundMOC: NSManagedObjectContext, handler: Any)] = []
  var addListenerToBackgroundMOCHandlerClosure: ((DocumentReference, NSManagedObjectContext, Any) -> Void)?

  func addListener<T: FirebaseCodableManagedObject>(to documentRef: DocumentReference, backgroundMOC: NSManagedObjectContext, handler: @escaping (T?, Error?) -> Void) {
      addListenerToBackgroundMOCHandlerCallsCount += 1
      addListenerToBackgroundMOCHandlerReceivedArguments = (documentRef: documentRef, backgroundMOC: backgroundMOC, handler: handler)
      addListenerToBackgroundMOCHandlerReceivedInvocations.append((documentRef: documentRef, backgroundMOC: backgroundMOC, handler: handler))
      addListenerToBackgroundMOCHandlerClosure?(documentRef, backgroundMOC, handler)
  }

  //MARK: - addListener

  var addListenerToQueryHandlerCallsCount = 0
  var addListenerToQueryHandlerCalled: Bool {
      return addListenerToHandlerCallsCount > 0
  }
  var addListenerToQueryHandlerReceivedArguments: (query: Query, handler: (QuerySnapshot?, Error?) -> Void)?
  var addListenerToQueryHandlerReceivedInvocations: [(query: Query, handler: (QuerySnapshot?, Error?) -> Void)] = []
  var addListenerToQueryHandlerReturnValue: ListenerRegistration?
  var addListenerToQueryHandlerClosure: ((Query, @escaping (QuerySnapshot?, Error?) -> Void) -> ListenerRegistration?)?

  func addListener(to query: Query, handler: @escaping (QuerySnapshot?, Error?) -> Void) -> ListenerRegistration? {
      addListenerToQueryHandlerCallsCount += 1
      addListenerToQueryHandlerReceivedArguments = (query: query, handler: handler)
      addListenerToQueryHandlerReceivedInvocations.append((query: query, handler: handler))
      if let addListenerToQueryHandlerClosure = addListenerToQueryHandlerClosure {
        return addListenerToQueryHandlerClosure(query, handler)
      } else {
        return addListenerToQueryHandlerReturnValue
      }
  }

  //MARK: - addListener<T: FirebaseCodableManagedObject>

  var addListenerToQueryBackgroundMOCHandlerCallsCount = 0
  var addListenerToQueryBackgroundMOCHandlerCalled: Bool {
      return addListenerToBackgroundMOCHandlerCallsCount > 0
  }
  var addListenerToQueryBackgroundMOCHandlerReceivedArguments: (query: Query, backgroundMOC: NSManagedObjectContext, handler: Any)?
  var addListenerToQueryBackgroundMOCHandlerReceivedInvocations: [(query: Query, backgroundMOC: NSManagedObjectContext, handler: Any)] = []
  var addListenerToQueryBackgroundMOCHandlerReturnValue: ListenerRegistration?
  var addListenerToQueryBackgroundMOCHandlerClosure: ((Query, NSManagedObjectContext, Any) -> ListenerRegistration?)?

  func addListener<T: FirebaseCodableManagedObject>(to query: Query, backgroundMOC: NSManagedObjectContext, handler: @escaping ([T]?, Error?) -> Void) -> ListenerRegistration? {
      addListenerToQueryBackgroundMOCHandlerCallsCount += 1
      addListenerToQueryBackgroundMOCHandlerReceivedArguments = (query: query, backgroundMOC: backgroundMOC, handler: handler)
      addListenerToQueryBackgroundMOCHandlerReceivedInvocations.append((query: query, backgroundMOC: backgroundMOC, handler: handler))
      if let closure = addListenerToQueryBackgroundMOCHandlerClosure {
        return closure(query, backgroundMOC, handler)
      } else {
        return addListenerToQueryBackgroundMOCHandlerReturnValue
      }
  }

  //MARK: - createUser

  var createUserEmailPasswordCompletionCallsCount = 0
  var createUserEmailPasswordCompletionCalled: Bool {
      return createUserEmailPasswordCompletionCallsCount > 0
  }
  var createUserEmailPasswordCompletionReceivedArguments: (email: String, password: String, completion: (String?, FirebaseAuthError?) -> Void)?
  var createUserEmailPasswordCompletionReceivedInvocations: [(email: String, password: String, completion: (String?, FirebaseAuthError?) -> Void)] = []
  var createUserEmailPasswordCompletionClosure: ((String, String, @escaping (String?, FirebaseAuthError?) -> Void) -> Void)?

  func createUser(email: String, password: String, completion: @escaping (String?, FirebaseAuthError?) -> Void) {
      createUserEmailPasswordCompletionCallsCount += 1
      createUserEmailPasswordCompletionReceivedArguments = (email: email, password: password, completion: completion)
      createUserEmailPasswordCompletionReceivedInvocations.append((email: email, password: password, completion: completion))
      createUserEmailPasswordCompletionClosure?(email, password, completion)
  }

  //MARK: - signIn

  var signInEmailPasswordCompletionCallsCount = 0
  var signInEmailPasswordCompletionCalled: Bool {
      return signInEmailPasswordCompletionCallsCount > 0
  }
  var signInEmailPasswordCompletionReceivedArguments: (email: String, password: String, completion: (String?, FirebaseAuthError?) -> Void)?
  var signInEmailPasswordCompletionReceivedInvocations: [(email: String, password: String, completion: (String?, FirebaseAuthError?) -> Void)] = []
  var signInEmailPasswordCompletionClosure: ((String, String, @escaping (String?, FirebaseAuthError?) -> Void) -> Void)?

  func signIn(email: String, password: String, completion: @escaping (String?, FirebaseAuthError?) -> Void) {
      signInEmailPasswordCompletionCallsCount += 1
      signInEmailPasswordCompletionReceivedArguments = (email: email, password: password, completion: completion)
      signInEmailPasswordCompletionReceivedInvocations.append((email: email, password: password, completion: completion))
      signInEmailPasswordCompletionClosure?(email, password, completion)
  }

  //MARK: - signOut

  var signOutThrowableError: Error?
  var signOutCallsCount = 0
  var signOutCalled: Bool {
      return signOutCallsCount > 0
  }
  var signOutClosure: (() throws -> Void)?

  func signOut() throws {
      if let error = signOutThrowableError {
        throw error
      }
      signOutCallsCount += 1
      try signOutClosure?()
  }

}
