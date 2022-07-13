//
//  NetworkingError.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 17/04/2022.
//

import Foundation

public enum NetworkError : Error {
    case invalidUrl(url: String = "")
    case parametersNil
    case decodingFailed
    case encodingFailed
    case missingURL
    case parametersError
    case httpResponseError(statusCode: Int)
    
    var description: String {
        switch self {
        case .parametersNil: return "Parameters were nil"
        case .decodingFailed: return "data decoding failed"
        case .encodingFailed: return "data encoding failed"
        case .missingURL: return "URL is nil"
        case let .invalidUrl(url): return "The url is invalid: \(url)"
        case .parametersError: return "invalid parameters"
        case let .httpResponseError(statusCode): return getStatusCodeErrorDescription(statusCode).description
        }
    }
    
    var localizedUserFriendlyDescription: String {
        switch self {
        // Add custom user friendly description for each error case here
        case let .httpResponseError(statusCode):
            return getStatusCodeErrorDescription(statusCode).localizedUserFriendlyDescription
        default: return "Something went wrong".localized
        }
    }
    
    var localizedUserFriendlyAdvice: String {
        switch self {
        // Add custom user friendly advice for each error case here
        case let .httpResponseError(statusCode):
            return getStatusCodeErrorDescription(statusCode).localizedUserFriendlyAdvice
        default: return "Try again later".localized
        }
    }
    

    private func getStatusCodeErrorDescription(_ statusCode: Int)
    -> (description: String, localizedUserFriendlyDescription: String, localizedUserFriendlyAdvice: String) {
        var statusCodeDescription = "statusCode: \(statusCode) "
        var statusCodeLocalizedUserFriendlyDescription = ""
        var statusCodeLocalizedUserFriendlyAdvice = ""
        
        switch statusCode {
        case 401:
            statusCodeDescription += "Authentication Required"
            statusCodeLocalizedUserFriendlyDescription = "Login required".localized
            statusCodeLocalizedUserFriendlyAdvice = "login".localized
        case 403:
            statusCodeDescription += "Forbidden"
            statusCodeLocalizedUserFriendlyDescription = "You don't have permission".localized
        case 408:
            statusCodeDescription += "Request Timeout"
            statusCodeLocalizedUserFriendlyDescription = "Request timed out".localized
            statusCodeLocalizedUserFriendlyAdvice = "Check internet connection and try again later".localized
        case 401...500:
            statusCodeDescription += "Bad request"
        case 501...599:
            statusCodeDescription += "Server error"
        case 600:
            statusCodeDescription += "Outdated"
        default:
            statusCodeDescription += "Request failed"
        }
        
        return (statusCodeDescription, statusCodeLocalizedUserFriendlyDescription, statusCodeLocalizedUserFriendlyAdvice)
    }
}
