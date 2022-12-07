//
//  EncodingAndDecodingErrors.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 27/11/2022.
//

import Foundation

enum EncodingError: UserFriendlyError {
    case failedToEncode(description: String = "Failed To Encode object",
                        userFriendlyDescription: String? = nil,
                        userFriendlyAdvice: String? = nil,
                        isFatal: Bool = false)
    
    var associatedValues: (description: String, userFriendlyDescription: String, userFriendlyAdvice: String, isFatal: Bool) {
        switch self {
        case let .failedToEncode(description, userFriendlyDescription, userFriendlyAdvice, isFatal):
            return (description,
                    userFriendlyDescription ?? defaultUserFriendlyDescription,
                    userFriendlyAdvice ?? defaultUserFriendlyAdvice,
                    isFatal)
        }
    }
    
}

enum DecodingError: UserFriendlyError {
    case failedToDecode(description: String = "Failed To decode object",
                        userFriendlyDescription: String? = nil,
                        userFriendlyAdvice: String? = nil,
                        isFatal: Bool = false)
    
    var associatedValues: (description: String, userFriendlyDescription: String, userFriendlyAdvice: String, isFatal: Bool) {
        switch self {
        case let .failedToDecode(description, userFriendlyDescription, userFriendlyAdvice, isFatal):
            return (description,
                    userFriendlyDescription ?? defaultUserFriendlyDescription,
                    userFriendlyAdvice ?? defaultUserFriendlyAdvice,
                    isFatal)
        }
    }
    
}
