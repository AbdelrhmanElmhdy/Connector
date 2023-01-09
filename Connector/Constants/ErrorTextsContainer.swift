//
//  ErrorTextsContainer.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 02/01/2023.
//

import Foundation

class ErrorTextsContainer {
	struct UserFriendlyErrorTextsContainer {
		let description: String
		let userDescription: String
		let userAdvice: String
	}
	
	static let noInternetConnection = "No Internet Connection".localized
	static let invalidEmail = "Invalid email".localized
	static let shortPassword = "Password must be at least 8 characters long".localized
	
	static let oneUpperCaseLetter = "1 upper case letter".localized
	static let oneLowerCaseLetter = "1 lower case letter".localized
	static let oneDigit = "1 digit".localized
	
	static let passwordConfirmationMismatch = "Passwords don't match".localized
	
	static let somethingWentWrong = "Something went wrong!".localized
	
	static let tryAgainLater = "Try again later".localized
	
	static let loginAgainSuggestion = "Please login again".localized
	
	static let userIdUnavailable = "User id not found"
	
	static let userDataNotFound = "User data not found"
	
	static let networkError = UserFriendlyErrorTextsContainer(
		description: "Network error occurred during the operation",
		userDescription: "No internet connection".localized,
		userAdvice: "Check your internet connection and try again".localized
	)
	
	static let userNotFoundError = UserFriendlyErrorTextsContainer(
		description: "The user account was not found",
		userDescription: "Account not found".localized,
		userAdvice: "Signup to create an account".localized
	)
	
	static let invalidEmailError = UserFriendlyErrorTextsContainer(
		description: "The email address is malformed",
		userDescription: "Invalid Email".localized,
		userAdvice: ""
	)
	
	static let emailAlreadyInUseError = UserFriendlyErrorTextsContainer(
		description: "The email used to attempt sign up already exists",
		userDescription: "This email is already in use".localized,
		userAdvice: ""
	)
	
	static let weakPasswordError = UserFriendlyErrorTextsContainer(
		description: "Password is considered too weak",
		userDescription: "Password too weak".localized,
		userAdvice: "Please enter a strong password with at least 1 digit, 1 lower cased letter, 1 upper cased letter".localized
	)
	
	static let wrongPasswordError = UserFriendlyErrorTextsContainer(
		description: "The user attempted to sign in with a wrong password",
		userDescription: "Incorrect password".localized,
		userAdvice: ""
	)
	
	static func mustBeAtLeast(ofLength minimumLength: Int) -> String {
		"must be at least \(minimumLength) characters long".localized
	}
	
	static func passwordMustContainAtLeast(_ requiredConditions: [String]) -> String {
		"Password must contain at least".localized + " " + requiredConditions.joinedAsSentence()
	}
	
	static func enter(_ requiredValue: String) -> String {
		"Enter".localized + " " + requiredValue.localized
	}
}
