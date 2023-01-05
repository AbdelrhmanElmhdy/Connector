//
//  AuthNetworkServiceTests.swift
//  ConnectorTests
//
//  Created by Abdelrhman Elmahdy on 18/12/2022.
//

import XCTest
import FirebaseAuth
import CoreData
@testable import Connector

class AuthNetworkServiceTests: XCTestCase {
  let firebaseManagerMock = FirebaseManagerMock()
  let stubsFactory = StubsFactory(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
  
  func testLoginRunsCompletion() {
      // Given
      let sut = MainAuthNetworkService(firebaseManager: firebaseManagerMock)
      let didFinishLogin = XCTestExpectation(description: #function)
      firebaseManagerMock.signInEmailPasswordCompletionClosure = { _, _, completion in
        completion(nil, nil)
      }
      
      // When
      sut.login(email: "t@t.com", password: "1") { _, _ in
        didFinishLogin.fulfill()
      }
      
      // Then
      wait(for: [didFinishLogin], timeout: 0.1)
  }
  
  func testSignupRunsCompletion() {
      // Given
      let sut = MainAuthNetworkService(firebaseManager: firebaseManagerMock)
      let didFinishSignup = XCTestExpectation(description: #function)
      firebaseManagerMock.createUserEmailPasswordCompletionClosure = { _, _, completion in
        completion(nil, nil)
      }
      
      // When
      sut.signup(user: stubsFactory.makeUserStub(), password: "t"){ _, _ in
        didFinishSignup.fulfill()
      }
      
      // Then
      wait(for: [didFinishSignup], timeout: 0.1)
  }
  
  func testSignOutCallsFirebaseManagerSignOutMethodOnce() throws {
      // Given
      let sut = MainAuthNetworkService(firebaseManager: firebaseManagerMock)
      
      // When
      try sut.signOut()
      
      // Then
      XCTAssertEqual(firebaseManagerMock.signOutCallsCount, 1)
  }
  
  func testSignOutThrowsError() {
      // Given
      let sut = MainAuthNetworkService(firebaseManager: firebaseManagerMock)
      firebaseManagerMock.signOutThrowableError = FirebaseAuthError.somethingWentWrong(description: "")
      
      // Then
      XCTAssertThrowsError(try sut.signOut())
  }
}
