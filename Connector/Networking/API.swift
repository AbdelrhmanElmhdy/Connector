//
//  String + Ext.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 17/04/2022.
//

import Foundation

public enum API {
    case login(username: String, password: String)
    case signup(firstName: String, lastName: String, emailAddress: String, password: String)
}

extension API: Endpoint {
        
    var baseUrl: URL { URL(string: "https://www.connector.myapi.com/")! }
    
    var path: String {
        switch self {
        case .login: return "login"
        case .signup: return "signup"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .login, .signup: return .post
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case let .login(username, password):
            return ["username": username, "password": password]
        case let .signup(firstName, lastName, emailAddress, password):
            return ["firstName": firstName, "lastName": lastName, "emailAddress": emailAddress, "password": password]
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .login, .signup: return nil
        }
    }
}
