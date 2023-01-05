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
	
	case networkError(description: String = .errors.networkError.description,
										userFriendlyDescription: String? = .errors.networkError.userDescription,
										userFriendlyAdvice: String? = .errors.networkError.userAdvice,
										isFatal: Bool = false)
	
	case userNotFound(description: String = .errors.userNotFoundError.description,
										userFriendlyDescription: String? = .errors.userNotFoundError.userDescription,
										userFriendlyAdvice: String? = .errors.userNotFoundError.userAdvice,
										isFatal: Bool = false)
	
	case invalidEmail(description: String = .errors.invalidEmailError.description,
										userFriendlyDescription: String? = .errors.invalidEmailError.userDescription,
										userFriendlyAdvice: String? = "",
										isFatal: Bool = false)
	
	// MARK: User Creation Errors
	
	case emailAlreadyInUse(description: String = .errors.emailAlreadyInUseError.description,
												 userFriendlyDescription: String? = .errors.emailAlreadyInUseError.userDescription,
												 userFriendlyAdvice: String? = "",
												 isFatal: Bool = false)
	
	case weakPassword(description: String = .errors.weakPasswordError.description,
										userFriendlyDescription: String? = .errors.weakPasswordError.userDescription,
										userFriendlyAdvice: String? = .errors.weakPasswordError.userAdvice,
										isFatal: Bool = false)
	
	// MARK: User Login Errors
	
	case wrongPassword(description: String = .errors.wrongPasswordError.description,
										 userFriendlyDescription: String? = .errors.wrongPasswordError.userDescription,
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
