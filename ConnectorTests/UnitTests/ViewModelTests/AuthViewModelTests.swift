//
//  AuthViewModelTests.swift
//  ConnectorTests
//
//  Created by Abdelrhman Elmahdy on 19/12/2022.
//

import XCTest
import Foundation
@testable import Connector

class AuthViewModelTests: XCTestCase {
  let authServiceMock = AuthServiceMock()
  let userServiceMock = UserServiceMock()
  
  func createSUT() -> AuthViewModel {
      AuthViewModel(authService: authServiceMock, userService: userServiceMock)
  }
  
  func testEmptyValue() {
      // Given
      let sut = createSUT()
      let validatableFieldMock = ValidatableFieldMock()
      validatableFieldMock.value = ""
      
      // When
      let (isValid, _) = sut.nonEmptyFieldValidator(validatableFieldMock)
      
      // Then
      XCTAssertFalse(isValid)
  }
  
  func testNonEmptyValue() {
      // Given
      let sut = createSUT()
      let validatableFieldMock = ValidatableFieldMock()
      validatableFieldMock.value = "t"
      
      // When
      let (isValid, _) = sut.nonEmptyFieldValidator(validatableFieldMock)
      
      // Then
      XCTAssertTrue(isValid)
  }
  
  func testValidEmail() {
      // Given
      let sut = createSUT()
      let validatableFieldMock = ValidatableFieldMock()
      validatableFieldMock.value = "email@test.com"
      
      // When
      let (isValid, _) = sut.emailValidator(validatableFieldMock)
      
      // Then
      XCTAssertTrue(isValid)
  }
  
  func testInvalidEmail() {
      // Given
      let sut = createSUT()
      let validatableFieldMock = ValidatableFieldMock()
      validatableFieldMock.value = "email.com"
      
      // When
      let (isValid, errorMessage) = sut.emailValidator(validatableFieldMock)
      
      // Then
      XCTAssertFalse(isValid)
      XCTAssertNotNil(errorMessage)
  }
  
  func testNoInvalidInput() {
      // Given
      let sut = createSUT()
      let validatableFieldMock = ValidatableFieldMock()
      let stubbedIsValidState = true
      validatableFieldMock.validateValidatorsReturnValue = (stubbedIsValidState, "")
      
      // When
      let invalidInputsErrorMessages = sut.validateInputs(validatableFieldMock)
      
      // Then
      XCTAssertEqual(invalidInputsErrorMessages.keys.count, 0)
  }
  
  func testInvalidInput() {
      // Given
      let sut = createSUT()
      let validatableFieldMock = ValidatableFieldMock()
      let stubbedIsValidState = false
      let stubbedErrorMessage = "Error Message"
      validatableFieldMock.validateValidatorsReturnValue = (stubbedIsValidState, stubbedErrorMessage)
      
      // When
      let invalidInputsErrorMessages = sut.validateInputs(validatableFieldMock)
      
      // Then
      XCTAssertEqual(invalidInputsErrorMessages.keys.count, 1)
      XCTAssertEqual(invalidInputsErrorMessages[validatableFieldMock], stubbedErrorMessage)
  }
  
  func testCallsPresentErrorMessageOnEachInvalidInputWithCorrectArgument() {
      // Given
      let sut = createSUT()
      let validatableFieldMock1 = ValidatableFieldMock()
      let stubbedIsValidState1 = false
      let stubbedErrorMessage1 = "Error Message 1"
      validatableFieldMock1.validateValidatorsReturnValue = (stubbedIsValidState1, stubbedErrorMessage1)
      
      let validatableFieldMock2 = ValidatableFieldMock()
      let stubbedIsValidState2 = false
      let stubbedErrorMessage2 = "Error Message 2"
      validatableFieldMock2.validateValidatorsReturnValue = (stubbedIsValidState2, stubbedErrorMessage2)
      
      // When
      let invalidInputsErrorMessages = sut.validateInputs(validatableFieldMock1, validatableFieldMock2)
      sut.presentErrorMessagesForInvalidInputs(invalidInputsErrorMessages: invalidInputsErrorMessages)
      
      // Then
      XCTAssertEqual(invalidInputsErrorMessages.keys.count, 2)
      XCTAssertEqual(validatableFieldMock1.presentErrorMessageReceivedErrorMessage, stubbedErrorMessage1)
      XCTAssertEqual(validatableFieldMock2.presentErrorMessageReceivedErrorMessage, stubbedErrorMessage2)
  }
  
}
