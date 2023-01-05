//
//  SignupViewModelTests.swift
//  ConnectorTests
//
//  Created by Abdelrhman Elmahdy on 19/12/2022.
//

import Foundation
import XCTest
import Combine
import CoreData
@testable import Connector

class SignupViewModelTests: XCTestCase {
  let authServiceMock = AuthServiceMock()
  let userServiceMock = UserServiceMock()
  var subscriptions = Set<AnyCancellable>()
  
  let stubsFactory = StubsFactory(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
  
  func createSUT() -> SignupViewModel {
      SignupViewModel(authService: authServiceMock, userService: userServiceMock)
  }
  
  func testInvalidShortPassword() {
      // Given
      let sut = createSUT()
      let validatableFieldMock = ValidatableFieldMock()
      validatableFieldMock.value = "Ab34567"
      
      // When
      let (isValid, errorMessage) = sut.passwordMinimumLengthValidator(validatableFieldMock)
      
      // Then
      XCTAssertFalse(isValid)
      XCTAssertNotNil(errorMessage)
  }
  
  func testWeakPassword() {
      // Given
      let sut = createSUT()
      let validatableFieldMock = ValidatableFieldMock()
      validatableFieldMock.value = "12345678"
      
      // When
      let (isValid, errorMessage) = sut.passwordComplexityValidator(validatableFieldMock)
      
      // Then
      XCTAssertFalse(isValid)
      XCTAssertNotNil(errorMessage)
  }
  
  func testWeakNoLowerCasePassword() {
      // Given
      let sut = createSUT()
      let validatableFieldMock = ValidatableFieldMock()
      validatableFieldMock.value = "A2345678"
      
      // When
      let (isValid, errorMessage) = sut.passwordComplexityValidator(validatableFieldMock)
      
      // Then
      XCTAssertFalse(isValid)
      XCTAssertNotNil(errorMessage)
  }
  
  func testWeakNoUpperCasePassword() {
      // Given
      let sut = createSUT()
      let validatableFieldMock = ValidatableFieldMock()
      validatableFieldMock.value = "a2345678"
      
      // When
      let (isValid, errorMessage) = sut.passwordComplexityValidator(validatableFieldMock)
      
      // Then
      XCTAssertFalse(isValid)
      XCTAssertNotNil(errorMessage)
  }
  
  func testValidStrongPassword() {
      // Given
      let sut = createSUT()
      let validatableFieldMock = ValidatableFieldMock()
      validatableFieldMock.value = "Ab345678"
      
      // When
      let (isValid, _) = sut.passwordComplexityValidator(validatableFieldMock)
      
      // Then
      XCTAssertTrue(isValid)
  }
  
  func testUserCreation() {
      // Given
      let sut = createSUT()
      let stubbedFirstName = "FirstName"
      let stubbedLastName = "LastName"
      let stubbedUsername = "username"
      let stubbedEmail = "email@test.com"
      userServiceMock.createUserReturnValue = User(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
      
      // When
      let user = sut.createUser(firstName: stubbedFirstName, lastName: stubbedLastName, username: stubbedUsername, email: stubbedEmail)
      
      // Then
      XCTAssertEqual(user.id, "")
      XCTAssertEqual(user.firstName, stubbedFirstName)
      XCTAssertEqual(user.lastName, stubbedLastName)
      XCTAssertEqual(user.username, stubbedUsername)
      XCTAssertEqual(user.email, stubbedEmail)
  }
  
  func testSuccessfulSignup() {
      // Given
      authServiceMock.signupUserPasswordReturnValue = Future() { $0(.success(())) }
      let sut = createSUT()
      let didFinishSignup = XCTestExpectation(description: #function)
      
      // When
      sut.signup(user: stubsFactory.makeUserStub(), password: "t")
        .sink { completion in
            switch completion {
            case .failure:
              didFinishSignup.isInverted = true
              didFinishSignup.fulfill()
            case .finished:
              didFinishSignup.fulfill()
            }
        } receiveValue: {}
        .store(in: &subscriptions)
      
      // Then
      wait(for: [didFinishSignup], timeout: 0.1)
  }
  
  func testSignupShouldFailWhenCompletionIsFailure() {
      // Given
      authServiceMock.signupUserPasswordReturnValue = Future() { $0(.failure(FirebaseAuthError.emailAlreadyInUse())) }
      
      let sut = createSUT()
      let didFailSignup = XCTestExpectation(description: #function)
      
      // When
      sut.signup(user: stubsFactory.makeUserStub(), password: "t")
        .sink { completion in
            switch completion {
            case .failure:
              didFailSignup.fulfill()
            case .finished:
              didFailSignup.isInverted = true
              didFailSignup.fulfill()
            }
        } receiveValue: {}
        .store(in: &subscriptions)
      
      // Then
      wait(for: [didFailSignup], timeout: 0.1)
  }

}
