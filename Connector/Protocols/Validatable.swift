//
//  Validatable.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 02/10/2022.
//

import Foundation

protocol Validatable {
    /// A call back function that takes in  candidate and performs some custom validations on it.
    /// - parameter candidate: The validatable object that is to be checked.
    /// - returns: A (Bool, String) tuple containing two elements isValid and errorMessage respectively.
    typealias Validator = (_ candidate: Validatable) -> (isValid: Bool, errorMessage: String)
    
    /// Can be used in generic error messages where verb-based names (e.g: Confirm Password) won't fit.
    var nameAsNoun: String { get set }
    
    /// The value that's to be validated.
    var value: String { get set }
    
    /// The checks constrained on the validatable object.
    var validators: [Validator] { get set }
    
    func validate(validators: [Validator]) -> (isValid: Bool, errorMessage: String?)
    func presentErrorMessage(_ errorMessage: String?)
}

extension Validatable {
    
    /// - returns:  The error message of the first unmet condition encountered.
    func validate(validators: [Validator]) -> (isValid: Bool, errorMessage: String?) {
        for validator in validators {
            let (isValid, errorMessage) = validator(self)
            if !isValid {
                return (false, errorMessage)
            }
        }
        
        return (true, nil)
    }
    
}
