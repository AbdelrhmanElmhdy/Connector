//
//  AuthCoordination.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 26/11/2022.
//

import Foundation

protocol LoggingIn: AnyObject {
    func loginWithExistingAccount()
}

protocol CreatingAccount: AnyObject {
    func createNewAccount()
}

protocol Authenticating: AnyObject {
    func didFinishAuthentication()
}
