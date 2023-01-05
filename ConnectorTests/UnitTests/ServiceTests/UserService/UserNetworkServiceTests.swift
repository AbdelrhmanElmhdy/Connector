//
//  UserNetworkServiceTests.swift
//  ConnectorTests
//
//  Created by Abdelrhman Elmahdy on 18/12/2022.
//

import XCTest
import CoreData
import FirebaseFirestore
@testable import Connector

class UserNetworkServiceTests: XCTestCase {
  let firebaseManagerMock: FirebaseManagerMock = {
      let firebaseManagerMock = FirebaseManagerMock()
      firebaseManagerMock.firestoreDB = Firestore.firestore()
      return firebaseManagerMock
  }()
  
  let stubsFactory = StubsFactory(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
  
  func testSettingUserDataCallsSetDataMethodOnFirebaseManagerWithCorrectPathAndObjcet() {
      // Given
      let sut = MainUserNetworkService(firebaseManager: firebaseManagerMock)
      let stubbedUser = stubsFactory.makeUserStub()
      
      // When
      sut.setUserData(user: stubbedUser)
      let shouldBePassedPath = firebaseManagerMock.firestoreDB.collection("users").document(stubbedUser.id).path
      let shouldBePassedObject = stubbedUser
      
      let passedPath = firebaseManagerMock.setDataOnUsingObjectReceivedArguments?.documentRef.path
      let passedObject = firebaseManagerMock.setDataOnUsingObjectReceivedArguments!.object
      
      // Then
      XCTAssertEqual(passedPath, shouldBePassedPath)
      XCTAssertEqual(passedObject, shouldBePassedObject)
  }
  
  func testFetchUserPassesCorrectUserDocumentPathToFirebaseManager() {
      // Given
      let sut = MainUserNetworkService(firebaseManager: firebaseManagerMock)
      
      // When
      sut.fetchUser(withId: "1", backgroundMOC: NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)) { _,_ in
      }
      let shouldBePassedUserDocumentRef = firebaseManagerMock.firestoreDB.collection("users").document("1")
      let passedUserDocumentRef = firebaseManagerMock.getDocumentFromBackgroundMOCCompletionReceivedArguments?.documentRef
      
      // Then
      XCTAssertEqual(passedUserDocumentRef, shouldBePassedUserDocumentRef)
  }
  
  func testUsersSearchPassesCorrectQueryToFirebaseManager() {
      // Given
      let sut = MainUserNetworkService(firebaseManager: firebaseManagerMock)
      
      // When
      sut.searchForUsers(withUsernameSimilarTo: "u", backgroundMOC: NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)) { _, _ in
      }
      
      let shouldBePassedQuery = firebaseManagerMock.firestoreDB.collection("users").whereField("username", isEqualTo: "u")
      let passedQuery = firebaseManagerMock.addListenerToQueryBackgroundMOCHandlerReceivedArguments?.query
      
      // Then
      XCTAssertEqual(passedQuery, shouldBePassedQuery)
  }
  
}
