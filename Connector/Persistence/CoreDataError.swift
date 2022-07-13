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
                      userFriendlyAdvice: String = defaultUserFriendlyAdvice,
                      context: String? = nil)
    
    case failedToRetrieve(description: String = defaultFailedToRetrieveErrorDescription,
                          userFriendlyDescription: String = defaultUserFriendlyDescription,
                          userFriendlyAdvice: String = defaultUserFriendlyAdvice,
                          context: String? = nil)
    
    case invalidContext(description: String = defaultInvalidContextErrorDescription,
                          userFriendlyDescription: String = defaultUserFriendlyDescription,
                          userFriendlyAdvice: String = defaultUserFriendlyAdvice,
                          context: String? = nil)
    
    case decoderMissingManagedObjectContext(description: String = defaultDecoderMissingContextErrorDescription,
                                            userFriendlyDescription: String = defaultUserFriendlyDescription,
                                            userFriendlyAdvice: String = defaultUserFriendlyAdvice,
                                            context: String? = nil)
    
    
    var associatedValues: (description: String, userFriendlyDescription: String, userFriendlyAdvice: String, context: String?) {
        switch self {
        case let .failedToSave(description, userFriendlyDescription, userFriendlyAdvice, context),
             let .failedToRetrieve(description, userFriendlyDescription, userFriendlyAdvice, context),
             let .invalidContext(description, userFriendlyDescription, userFriendlyAdvice, context),
             let .decoderMissingManagedObjectContext(description, userFriendlyDescription, userFriendlyAdvice, context):
            return (description, userFriendlyDescription, userFriendlyAdvice, context)
        }
    }
}
