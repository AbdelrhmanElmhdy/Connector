//
//  SignupViewModel.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import UIKit
import Combine

fileprivate let passwordLengthMessage = "Password must be at least 8 characters long".localized

fileprivate let passwordComplexityMessageOpening = "Password must contain at least ".localized
fileprivate let oneUpperCaseLetter = "1 upper case letter".localized
fileprivate let oneLowerCaseLetter = "1 lower case letter".localized
fileprivate let oneDigit = "1 digit".localized

fileprivate let passwordConfirmationMismatchMessage = "Passwords don't match".localized

class SignupViewModel: AuthViewModel {
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
        
        let errorMessage = isValid ? "" : passwordComplexityMessageOpening + missingRequirements.joinedAsSentence()
        
        return (isValid, errorMessage)
    }
    
    var passwordConfirmationMatchingValidator: Validatable.Validator {
        return { [weak self] candidate in
            return (candidate.value == self?.password, passwordConfirmationMismatchMessage)
        }
    }
        
    // MARK: State
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""
    
    // MARK: Business Logic
    
    func createUser(firstName: String, lastName: String, username: String, email: String) -> User {
        let user = userService.createUser()
        
        user.id = ""
        user.firstName = firstName
        user.lastName = lastName
        user.username = username.lowercased()
        user.email = email
        
        return user
    }
        
    func signup(user: User, password: String) -> Future <Void, Error> {
        return authService.signup(user: user, password: password)
    }
}
