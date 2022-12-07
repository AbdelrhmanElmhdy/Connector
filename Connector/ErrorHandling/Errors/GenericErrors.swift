//
//  GenericErrors.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/07/2022.
//

import Foundation

enum GenericError: UserFriendlyError {
    case somethingWentWrong(description: String = "Something went wrong",
                            userFriendlyDescription: String? = nil,
                            userFriendlyAdvice: String? = nil,
                            isFatal: Bool = false)
    
    var associatedValues: (description: String, userFriendlyDescription: String, userFriendlyAdvice: String, isFatal: Bool) {
        switch self {
        case let .somethingWentWrong(description, userFriendlyDescription, userFriendlyAdvice, isFatal):
            return (description,
                    userFriendlyDescription ?? defaultUserFriendlyDescription,
                    userFriendlyAdvice ?? defaultUserFriendlyAdvice,
                    isFatal)
        }
    }
}

enum UnwrappingError: UserFriendlyError {
    case failedToUnwrapUser(description: String = "User is nil",
                            userFriendlyDescription: String? = nil,
                            userFriendlyAdvice: String? = nil,
                            isFatal: Bool = false)
    
    case failedToUnwrapChatRoom(description: String = "ChatRoom is nil",
                                userFriendlyDescription: String? = nil,
                                userFriendlyAdvice: String? = nil,
                                isFatal: Bool = false)
    
    case failedToUnwrapMessage(description: String = "Message is nil",
                               userFriendlyDescription: String? = nil,
                               userFriendlyAdvice: String? = nil,
                               isFatal: Bool = false)
    
    case failedToUnwrapWeakVariable(description: String,
                                    userFriendlyDescription: String? = nil,
                                    userFriendlyAdvice: String? = nil,
                                    isFatal: Bool = false)
    
    case failedToUnwrapEntityName(description: String = "Entity name is nil",
                                  userFriendlyDescription: String? = nil,
                                  userFriendlyAdvice: String? = nil,
                                  isFatal: Bool = false)

    var associatedValues: (description: String, userFriendlyDescription: String, userFriendlyAdvice: String, isFatal: Bool) {
        switch self {
        case let .failedToUnwrapUser(description, userFriendlyDescription, userFriendlyAdvice, isFatal),
             let .failedToUnwrapChatRoom(description, userFriendlyDescription, userFriendlyAdvice, isFatal),
             let .failedToUnwrapMessage(description, userFriendlyDescription, userFriendlyAdvice, isFatal),
             let .failedToUnwrapWeakVariable(description, userFriendlyDescription, userFriendlyAdvice, isFatal),
             let .failedToUnwrapEntityName(description, userFriendlyDescription, userFriendlyAdvice, isFatal):
            return (description,
                    userFriendlyDescription ?? defaultUserFriendlyDescription,
                    userFriendlyAdvice ?? defaultUserFriendlyAdvice,
                    isFatal)
        }
    }
}

fileprivate let loginAgainAdvice = "Please login again".localized

/// Fatal error
enum MissingCriticalDataError: UserFriendlyError {
    case currentUsernameNotFound(description: String = "Current username is an empty string",
                                 userFriendlyDescription: String? = nil,
                                 userFriendlyAdvice: String? = loginAgainAdvice)
    

    case currentUserNotFound(description: String = "Current user is nil",
                             userFriendlyDescription: String? = nil,
                             userFriendlyAdvice: String? = loginAgainAdvice)
    
    var associatedValues: (description: String, userFriendlyDescription: String, userFriendlyAdvice: String, isFatal: Bool) {
        switch self {
        case let .currentUsernameNotFound(description, userFriendlyDescription, userFriendlyAdvice),
             let .currentUserNotFound(description, userFriendlyDescription, userFriendlyAdvice):
            return (description,
                    userFriendlyDescription ?? defaultUserFriendlyDescription,
                    userFriendlyAdvice ?? defaultUserFriendlyAdvice,
                    true)
        }
    }
}

enum InvalidAccessError: UserFriendlyError {
    case invalidAccess(description: String,
                       userFriendlyDescription: String? = nil,
                       userFriendlyAdvice: String? = nil,
                       isFatal: Bool = false)
    
    var associatedValues: (description: String, userFriendlyDescription: String, userFriendlyAdvice: String, isFatal: Bool) {
        switch self {
        case let .invalidAccess(description, userFriendlyDescription, userFriendlyAdvice, isFatal):
            return (description,
                    userFriendlyDescription ?? defaultUserFriendlyDescription,
                    userFriendlyAdvice ?? defaultUserFriendlyAdvice,
                    isFatal)
        }
    }
}
