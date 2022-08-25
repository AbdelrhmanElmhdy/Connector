//
//  CoreDataError.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/07/2022.
//

import Foundation

fileprivate let defaultFailedToSaveErrorDescription = "Failed to save object(s)"
fileprivate let defaultFailedToRetrieveErrorDescription = "Failed to retrieve object(s)"
fileprivate let defaultInvalidContextErrorDescription = "Invalid or no context"
fileprivate let defaultDecoderMissingContextErrorDescription = "no context found in json decoder"

fileprivate let defaultUserFriendlyDescription = "Something went wrong!".localized
fileprivate let defaultUserFriendlyAdvice = "Try again later".localized

enum CoreDataError: Error, UserFriendlyError {

    /// - parameter context: A sentence describing the attempted action written in the format "trying to + attempted action"
    case failedToSave(description: String = defaultFailedToSaveErrorDescription,
                      userFriendlyDescription: String = defaultUserFriendlyDescription,
                      userFriendlyAdvice: String = defaultUserFriendlyAdvice)
    
    case failedToRetrieve(description: String = defaultFailedToRetrieveErrorDescription,
                          userFriendlyDescription: String = defaultUserFriendlyDescription,
                          userFriendlyAdvice: String = defaultUserFriendlyAdvice)
    
    case invalidContext(description: String = defaultInvalidContextErrorDescription,
                          userFriendlyDescription: String = defaultUserFriendlyDescription,
                          userFriendlyAdvice: String = defaultUserFriendlyAdvice)
    
    case decoderMissingManagedObjectContext(description: String = defaultDecoderMissingContextErrorDescription,
                                            userFriendlyDescription: String = defaultUserFriendlyDescription,
                                            userFriendlyAdvice: String = defaultUserFriendlyAdvice)
    
    
    var associatedValues: (description: String, userFriendlyDescription: String, userFriendlyAdvice: String) {
        switch self {
        case let .failedToSave(description, userFriendlyDescription, userFriendlyAdvice),
             let .failedToRetrieve(description, userFriendlyDescription, userFriendlyAdvice),
             let .invalidContext(description, userFriendlyDescription, userFriendlyAdvice),
             let .decoderMissingManagedObjectContext(description, userFriendlyDescription, userFriendlyAdvice):
            return (description, userFriendlyDescription, userFriendlyAdvice)
        }
    }
}
