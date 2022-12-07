//
//  ErrorsManager.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 19/04/2022.
//

import Foundation

struct ErrorManager {
    static let shared = ErrorManager()
    
    // TODO: report error to database
    /// - Stub
    func reportError(_ error: Error) {
        if let error = error as? UserFriendlyError {
            reportError(error)
            return
        }
        
        print("ERROR: " + error.localizedDescription)
    }
    
    // TODO: report error to database
    /// - Stub
    func reportError(_ error: UserFriendlyError) {
        if error.isFatal {
            #if DEBUG
            fatalError(error.description)
            #endif
        }
        
        print("ERROR: " + error.description)
    }
    
    // TODO: report error to database
    /// - Stub
    func reportError(_ errorMessage: String) {
        print("ERROR: " + errorMessage)
    }
    
    
    func presentError(_ error: Error, reportError: Bool) {
        if let error = error as? UserFriendlyError {
            AlertPopup().presentAsError(withMessage: error.userFriendlyDescription, advice: error.userFriendlyAdvice)
        } else {
            AlertPopup().presentAsError(withMessage: "Something went wrong! Please try again later")
        }
        
        if reportError {
            self.reportError(error)
        }
    }
    
    func presentError(errorMessage: String, originalError: Error? = nil, reportError: Bool) {
        let error = originalError ?? GenericError.somethingWentWrong(description: errorMessage)
        presentError(error, reportError: reportError)
    }
    
    func presentSomethingWentWrongError(originalError: Error? = nil, reportError: Bool) {
        presentError(errorMessage: "Something went wrong! Please try again later".localized,
                     originalError: originalError,
                     reportError: reportError)
    }
    
    func presentNoCurrentUserError(error: Error? = nil, reportError: Bool) {
        let error = (error as? UserFriendlyError) ?? MissingCriticalDataError.currentUserNotFound(
            description: "Current user is nil"
        )
        
        presentError(error, reportError: reportError)
    }
}
