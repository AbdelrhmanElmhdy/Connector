//
//  UserFriendlyError.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/07/2022.
//

import Foundation

protocol UserFriendlyError: Error {
    
    var description: String { get }
    var userFriendlyDescription: String { get }
    var userFriendlyAdvice: String { get }
    
    var associatedValues: (description: String, userFriendlyDescription: String, userFriendlyAdvice: String) { get }
}

extension UserFriendlyError {
    
    var description: String {
        let (description, _, _) = associatedValues
        return "Error: " + description + Thread.callStackSymbols.joined(separator: "\n")
    }
    
    var userFriendlyDescription: String {
        return associatedValues.userFriendlyDescription
    }
    
    var userFriendlyAdvice: String {
        return associatedValues.userFriendlyAdvice
    }
    
}
