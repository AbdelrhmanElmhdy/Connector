//
//  FirebaseAuthError.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 10/12/2022.
//

import Foundation
import FirebaseAuth

enum FirebaseAuthError: UserFriendlyError {
    init?(_ error: Error?) {
        guard let error = error as? NSError else { return nil }
        let firebaseAuthError = AuthErrorCode(_nsError: error)
        
        switch firebaseAuthError.code {
        case .networkError:
            self = .networkError()
        
        case .userNotFound:
            self = .userNotFound()
        
        case .invalidEmail:
            self = .invalidEmail()
        
        case .emailAlreadyInUse:
            self = .emailAlreadyInUse()
        
        case .weakPassword:
            self = .weakPassword()
        
        case .wrongPassword:
            self = .wrongPassword()
        
        default:
            self = .somethingWentWrong(description: error.description)
        }
    }
    
    // MARK: General Errors
    case somethingWentWrong(description: String,
                            userFriendlyDescription: String? = nil,
                            userFriendlyAdvice: String? = nil,
                            isFatal: Bool = true)
    
    case networkError(description: String = "Network error occurred during the operation",
                      userFriendlyDescription: String? = "No internet connection".localized,
                      userFriendlyAdvice: String? = "Check your internet connection and try again".localized,
                      isFatal: Bool = false)
    
    case userNotFound(description: String = "The user account was not found",
                      userFriendlyDescription: String? = "Account not found".localized,
                      userFriendlyAdvice: String? = "Signup to create an account".localized,
                      isFatal: Bool = false)
        
    case invalidEmail(description: String = "The email address is malformed",
                      userFriendlyDescription: String? = "Invalid Email".localized,
                      userFriendlyAdvice: String? = "",
                      isFatal: Bool = false)
        
    // MARK: User Creation Errors
    
    case emailAlreadyInUse(description: String = "The email used to attempt sign up already exists.",
                           userFriendlyDescription: String? = "This email is already in use".localized,
                           userFriendlyAdvice: String? = "Provide different email or tap the forgot password button".localized,
                           isFatal: Bool = false)
    
    case weakPassword(description: String = "Password that is considered too weak",
                      userFriendlyDescription: String? = "Password too weak".localized,
                      userFriendlyAdvice: String? = "Please enter a strong password with at least 1 digit, 1 lower cased letter, 1 upper cased letter".localized,
                      isFatal: Bool = false)
    
    // MARK: User Login Errors
    
    case wrongPassword(description: String = "The user attempted to sign in with a wrong password",
                       userFriendlyDescription: String? = "Incorrect password".localized,
                       userFriendlyAdvice: String? = "",
                       isFatal: Bool = false)
    
    var associatedValues: (description: String, userFriendlyDescription: String, userFriendlyAdvice: String, isFatal: Bool) {
        switch self {
        case let .somethingWentWrong(description, userFriendlyDescription, userFriendlyAdvice, isFatal),
             let .networkError(description, userFriendlyDescription, userFriendlyAdvice, isFatal),
             let .userNotFound(description, userFriendlyDescription, userFriendlyAdvice, isFatal),
             let .invalidEmail(description, userFriendlyDescription, userFriendlyAdvice, isFatal),
             let .emailAlreadyInUse(description, userFriendlyDescription, userFriendlyAdvice, isFatal),
             let .weakPassword(description, userFriendlyDescription, userFriendlyAdvice, isFatal),
             let .wrongPassword(description, userFriendlyDescription, userFriendlyAdvice, isFatal):
            return (description,
                    userFriendlyDescription ?? defaultUserFriendlyDescription,
                    userFriendlyAdvice ?? defaultUserFriendlyAdvice,
                    isFatal)
        }
    }
    
}
