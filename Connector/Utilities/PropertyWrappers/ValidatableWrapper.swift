//
//  Validatable.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 05/01/2023.
//

import Foundation
import Combine

@propertyWrapper
struct PublishedValidatable<Value> {
	
	class ValidatableWrapper: Validatable {
		let objectID = UUID()
		
		@Published var value: Value
		var nounName: String
		var validators: [Validator]
		@Published var errorMessage: String = ""
		
		fileprivate init(value: Value, nounName: String, validators: [Validator]) {
			self.value = value
			self.nounName = nounName
			self.validators = validators
		}
	}
	
	var wrappedValue: Value {
		didSet {
			projectedValue.value = wrappedValue
		}
	}
	
	var projectedValue: ValidatableWrapper
	
	init(wrappedValue: Value, nounName: String, validators: [Validatable.Validator] = []) {
		self.wrappedValue = wrappedValue
		self.projectedValue = ValidatableWrapper(value: wrappedValue, nounName: nounName, validators: validators)
	}
	
}
