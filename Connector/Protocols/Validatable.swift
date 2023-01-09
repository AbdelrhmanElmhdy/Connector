//
//  Validatable.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 02/10/2022.
//

import Foundation

protocol Validatable: AnyObject, AutoMockable {
	/// A call back function that takes in a validatable candidate and validates it with some custom checks.
	/// - parameter candidate: The validatable object that is to be checked.
	/// - returns: A (Bool, String) tuple containing two elements isValid and errorMessage respectively.
	typealias Validator = (_ candidate: any Validatable) -> (isValid: Bool, errorMessage: String)
	associatedtype Value
	
	/// Can be used in generic error messages where verb-based names (e.g: Confirm Password) won't fit.
	var nounName: String { get set }
	
	/// The value that's to be validated.
	var value: Value { get }
	
	/// The checks constrained on the validatable object ordered by precedence .
	var validators: [Validator] { get set }
	var errorMessage: String { get set }
	
	func validate(using validators: [Validator]) -> (isValid: Bool, errorMessage: String?)
}

extension Validatable {
	
	/// - returns: The error message of the first unmet condition encountered.
	func validate(using validators: [Validator]) -> (isValid: Bool, errorMessage: String?) {
		for validator in validators {
			let (isValid, errorMessage) = validator(self)
			if !isValid {
				return (false, errorMessage)
			}
		}
		
		return (true, nil)
	}
	
}
