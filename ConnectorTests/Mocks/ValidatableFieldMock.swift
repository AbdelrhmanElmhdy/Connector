//
//  ValidatableFieldMock.swift
//  ConnectorTests
//
//  Created by Abdelrhman Elmahdy on 19/12/2022.
//

import Foundation
@testable import Connector

class ValidatableFieldMock: Validatable, Hashable {
  static func == (lhs: ValidatableFieldMock, rhs: ValidatableFieldMock) -> Bool {
      lhs.objectID == rhs.objectID
  }
  
  func hash(into hasher: inout Hasher) {
      hasher.combine(objectID)
  }
  
  let objectID = UUID()
  
  var nameAsNoun: String = ""
  
  var value: String = ""
  
  var validators: [Validator] = []
  
  
  //MARK: - validate

  var validateValidatorsCallsCount = 0
  var validateValidatorsCalled: Bool {
      return validateValidatorsCallsCount > 0
  }
  var validateValidatorsReceivedValidators: [Validator]?
  var validateValidatorsReceivedInvocations: [[Validator]] = []
  var validateValidatorsReturnValue: (isValid: Bool, errorMessage: String?)!
  var validateValidatorsClosure: (([Validator]) -> (isValid: Bool, errorMessage: String?))?

  func validate(validators: [Validator]) -> (isValid: Bool, errorMessage: String?) {
      validateValidatorsCallsCount += 1
      validateValidatorsReceivedValidators = validators
      validateValidatorsReceivedInvocations.append(validators)
      if let validateValidatorsClosure = validateValidatorsClosure {
        return validateValidatorsClosure(validators)
      } else {
        return validateValidatorsReturnValue
      }
  }

  //MARK: - presentErrorMessage

  var presentErrorMessageCallsCount = 0
  var presentErrorMessageCalled: Bool {
      return presentErrorMessageCallsCount > 0
  }
  var presentErrorMessageReceivedErrorMessage: String?
  var presentErrorMessageReceivedInvocations: [String?] = []
  var presentErrorMessageClosure: ((String?) -> Void)?

  func presentErrorMessage(_ errorMessage: String?) {
      presentErrorMessageCallsCount += 1
      presentErrorMessageReceivedErrorMessage = errorMessage
      presentErrorMessageReceivedInvocations.append(errorMessage)
      presentErrorMessageClosure?(errorMessage)
  }
  
  
}
