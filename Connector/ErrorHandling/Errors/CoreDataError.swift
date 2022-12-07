//
//  CoreDataError.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/07/2022.
//

import Foundation

enum CoreDataError: Error, UserFriendlyError {

    case failedToSave(description: String = "Failed to save object(s)",
                      userFriendlyDescription: String? = nil,
                      userFriendlyAdvice: String? = nil,
                      isFatal: Bool = false)
    
    case failedToRetrieve(description: String = "Failed to retrieve object(s)",
                          userFriendlyDescription: String? = nil,
                          userFriendlyAdvice: String? = nil,
                          isFatal: Bool = false)
    
    case invalidContext(description: String = "Invalid or no context",
                        userFriendlyDescription: String? = nil,
                        userFriendlyAdvice: String? = nil,
                        isFatal: Bool = false)
    
    case decoderMissingManagedObjectContext(description: String = "no context found in json decoder",
                                            userFriendlyDescription: String? = nil,
                                            userFriendlyAdvice: String? = nil,
                                            isFatal: Bool = false)
    
    var associatedValues: (description: String, userFriendlyDescription: String, userFriendlyAdvice: String, isFatal: Bool) {
        switch self {
        case let .failedToSave(description, userFriendlyDescription, userFriendlyAdvice, isFatal),
             let .failedToRetrieve(description, userFriendlyDescription, userFriendlyAdvice, isFatal),
             let .invalidContext(description, userFriendlyDescription, userFriendlyAdvice, isFatal),
             let .decoderMissingManagedObjectContext(description, userFriendlyDescription, userFriendlyAdvice, isFatal):
            return (description,
                    userFriendlyDescription ?? defaultUserFriendlyDescription,
                    userFriendlyAdvice ?? defaultUserFriendlyAdvice,
                    isFatal)
        }
    }
}
