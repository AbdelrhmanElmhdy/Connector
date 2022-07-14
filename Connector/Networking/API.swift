//
//  String + Ext.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 17/04/2022.
//

import Foundation

public enum API {
    case login(username: String, password: String)
    case signup(firstName: String, lastName: String, email: String, username: String, password: String)
    case searchUsers(username: String)
}

extension API: Endpoint {
        
    var baseUrl: URL { URL(string: "http://localhost:3000/")! }
    
    var path: String {
        switch self {
        case .login: return "login"
        case .signup: return "signup"
        case let .searchUsers(username): return "users?username=\(username)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .login, .signup: return .post
        case .searchUsers: return .get
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case let .login(username, password):
            return ["username": username, "password": password]
        case let .signup(firstName, lastName, email, username, password):
            return ["firstName": firstName,
                    "lastName": lastName,
                    "email": email,
                    "username": username,
                    "password": password]
            
        default: return nil
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .login, .signup: return ["Content-Type": "application/json"]
        default: return nil
        }
    }
}
