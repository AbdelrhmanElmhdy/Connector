//
//  AuthService.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 04/10/2022.
//

import Foundation
import Combine

protocol AuthService: AnyObject, AutoMockable {
    var userService: UserService? { get set }
    
    var isLoggedIn: Bool { get set }
    var username: String { get set }
    var userId: String { get set }
    
    func login(email: String, password: String) -> Future<Void, Error>
    func signup(user: User, password: String) -> Future<Void, Error>
    func signOut() throws
}
