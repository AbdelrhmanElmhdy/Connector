//
//  AuthViewModel.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 02/10/2022.
//

import UIKit
import Combine

fileprivate let invalidEmailMessage = "Invalid email".localized

class AuthViewModel {
    // MARK: Business Logic Constants
    
    let nonEmptyFieldValidator: Validatable.Validator = {
        (!$0.value.isEmpty, "Enter ".localized + $0.nameAsNoun)
    }
    
    let emailValidator: Validatable.Validator = { ($0.value.isEmail, invalidEmailMessage) }
        
    let authService: AuthService
    let userService: UserService
    
    // MARK: State
    
    @Published var isUserInteractionEnabled: Bool = true
    @Published var isLoading: Bool = false
    
    // MARK: Initialization
    
    init(authService: AuthService, userService: UserService) {
        self.authService = authService
        self.userService = userService
    }
    
    // MARK: Business Logic
    
    /// Validate each input against its validators and return the invalid inputs along with their respective error messages.
    /// - Parameters inputs: Validatable & Hashable objects that contain validators to be checked against.
    /// - Returns: An [Input: String] dictionary containing the invalid inputs as keys and their error messages as values.
    func validateInputs<Input: Validatable & Hashable>(_ inputs: Input...) -> [Input : String] {
        var invalidInputsErrorMessages: [Input : String] = [:]
        
        for input in inputs {
            let (isValid, errorMessage) = input.validate(validators: input.validators)
            if !isValid {
                invalidInputsErrorMessages[input] = errorMessage ?? ""
            }
        }
        
        return invalidInputsErrorMessages
    }
    
    // MARK: Convenience
    
    func presentErrorMessagesForInvalidInputs<InputField: Validatable>(invalidInputsErrorMessages: [InputField: String]) {
        for (input, errorMessage) in invalidInputsErrorMessages {
            input.presentErrorMessage(errorMessage)
        }
    }
    
    // Those functions only serve the code readability and the abstraction level conservation.
    func disableUserInteraction() { isUserInteractionEnabled = false }
    func showLoadingSpinner() { isLoading = true }
    func enableUserInteraction() { isUserInteractionEnabled = true }
    func hideLoadingSpinner() { isLoading = false }
}
