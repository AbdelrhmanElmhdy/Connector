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
  
  var nounName: String = ""
  
  var value: String = ""
  
  var validators: [Validator] = []
	
	var errorMessage: String = ""
  
  
  //MARK: - validate

  var validateValidatorsCallsCount = 0
  var validateValidatorsCalled: Bool {
      return validateValidatorsCallsCount > 0
  }
  var validateValidatorsReceivedValidators: [Validator]?
  var validateValidatorsReceivedInvocations: [[Validator]] = []
  var validateValidatorsReturnValue: (isValid: Bool, errorMessage: String?)!
  var validateValidatorsClosure: (([Validator]) -> (isValid: Bool, errorMessage: String?))?

  func validate(using validators: [Validator]) -> (isValid: Bool, errorMessage: String?) {
      validateValidatorsCallsCount += 1
		validateValidatorsReceivedValidators = validators
      validateValidatorsReceivedInvocations.append(validators)
      if let validateValidatorsClosure = validateValidatorsClosure {
        return validateValidatorsClosure(validators)
      } else {
        return validateValidatorsReturnValue
      }
  }
  
}
