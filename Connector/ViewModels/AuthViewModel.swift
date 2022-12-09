//
//  AuthViewModel.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 02/10/2022.
//

import Foundation
import UIKit
import Combine

fileprivate let invalidEmailMessage = "Invalid email".localized

fileprivate let passwordLengthMessage = "Password must be at least 8 characters long".localized
fileprivate let passwordComplexityMessageOpening = "Password must contain at least ".localized
fileprivate let oneUpperCaseLetter = "1 upper case letter".localized
fileprivate let oneLowerCaseLetter = "1 lower case letter".localized
fileprivate let oneDigit = "1 digit".localized

class AuthViewModel {
    // MARK: Business Logic Constants
    
    let nonEmptyFieldValidator: Validatable.Validator = {
        (!$0.value.isEmpty, "Enter ".localized + $0.nameAsNoun)
    }
    
    let emailValidator: Validatable.Validator = { ($0.value.isEmail, invalidEmailMessage) }
    
    let passwordMinimumLengthValidator: Validatable.Validator = { ($0.value.count >= 8, passwordLengthMessage) }
    
    /// Ensures candidate contains at least 1 upper case letter, 1 lower case letter and 1 digit
    let passwordComplexityValidator: Validatable.Validator = { candidate in
        var missingRequirements: [String] = []
        if !candidate.value.includesOneUpperCaseLetter { missingRequirements.append(oneUpperCaseLetter) }
        if !candidate.value.includesOneLowerCaseLetter { missingRequirements.append(oneLowerCaseLetter) }
        if !candidate.value.includesOneDigit { missingRequirements.append(oneDigit) }
        
        let isValid = candidate.value.includesOneUpperCaseLetter
            && candidate.value.includesOneLowerCaseLetter
            && candidate.value.includesOneDigit
        
        let errorMessage = passwordComplexityMessageOpening + missingRequirements.joinedAsSentence()
        
        return (isValid, errorMessage)
    }
    
    private let authServices: AuthServicesProtocol
    private let userServices: UserServicesProtocol
    
    // MARK: State
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""
    
    var serviceCancellable: AnyCancellable?
    
    init(authServices: AuthServicesProtocol, userServices: UserServicesProtocol) {
        self.authServices = authServices
        self.userServices = userServices
    }
    
    // MARK: Business Logic
    
    func createUser(firstName: String, lastName: String, username: String, email: String) -> User {
        let user = userServices.createUser()
        
        user.id = ""
        user.firstName = firstName
        user.lastName = lastName
        user.username = username.lowercased()
        user.email = email
        
        return user
    }
    
    func login(email: String, password: String) -> Future <Void, Error> {
        return authServices.login(email: email, password: password)
    }
    
    func signup(user: User, password: String) -> Future <Void, Error> {
        return authServices.signup(user: user, password: password)
    }
    
    func validateInputs(_ inputs: Validatable...) -> (invalidInputs: [Validatable], errorMessages: [String]) {
        var invalidInputs = Array<Validatable>()
        var errorMessages = Array<String>()
        
        for input in inputs {
            let (isValid, errorMessage) = input.validate(validators: input.validators)
            if !isValid {
                invalidInputs.append(input)
                errorMessages.append(errorMessage ?? "")
            }
        }
        
        return (invalidInputs, errorMessages)
    }
    
    func interpretFirebaseAuthenticationError(error: Error) -> UserFriendlyError? {
        print(error._code)
        return nil
    }
    
}
