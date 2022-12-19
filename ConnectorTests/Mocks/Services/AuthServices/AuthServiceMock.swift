// Generated using Sourcery 1.9.2 — https://github.com/krzysztofzablocki/Sourcery

import Foundation
import Combine
@testable import Connector

class AuthServiceMock: AuthService {

    init() {
        print("Initializing AuthServiceMock")
    }
    
    deinit {
        print("Deinitializing AuthServiceMock")
    }

    var userService: UserService?
    var isLoggedIn: Bool {
        get { return underlyingIsLoggedIn }
        set(value) { underlyingIsLoggedIn = value }
    }
    var underlyingIsLoggedIn: Bool!
    var username: String {
        get { return underlyingUsername }
        set(value) { underlyingUsername = value }
    }
    var underlyingUsername: String!
    var userId: String {
        get { return underlyingUserId }
        set(value) { underlyingUserId = value }
    }
    var underlyingUserId: String!

    //MARK: - login

    var loginEmailPasswordCallsCount = 0
    var loginEmailPasswordCalled: Bool {
        return loginEmailPasswordCallsCount > 0
    }
    var loginEmailPasswordReceivedArguments: (email: String, password: String)?
    var loginEmailPasswordReceivedInvocations: [(email: String, password: String)] = []
    var loginEmailPasswordReturnValue: Future<Void, Error>!
    var loginEmailPasswordClosure: ((String, String) -> Future<Void, Error>)?

    func login(email: String, password: String) -> Future<Void, Error> {
        loginEmailPasswordCallsCount += 1
        loginEmailPasswordReceivedArguments = (email: email, password: password)
        loginEmailPasswordReceivedInvocations.append((email: email, password: password))
        if let loginEmailPasswordClosure = loginEmailPasswordClosure {
            return loginEmailPasswordClosure(email, password)
        } else {
            return loginEmailPasswordReturnValue
        }
    }

    //MARK: - signup

    var signupUserPasswordCallsCount = 0
    var signupUserPasswordCalled: Bool {
        return signupUserPasswordCallsCount > 0
    }
    var signupUserPasswordReceivedArguments: (user: User, password: String)?
    var signupUserPasswordReceivedInvocations: [(user: User, password: String)] = []
    var signupUserPasswordReturnValue: Future<Void, Error>!
    var signupUserPasswordClosure: ((User, String) -> Future<Void, Error>)?

    func signup(user: User, password: String) -> Future<Void, Error> {
        signupUserPasswordCallsCount += 1
        signupUserPasswordReceivedArguments = (user: user, password: password)
        signupUserPasswordReceivedInvocations.append((user: user, password: password))
        if let signupUserPasswordClosure = signupUserPasswordClosure {
            return signupUserPasswordClosure(user, password)
        } else {
            return signupUserPasswordReturnValue
        }
    }

    //MARK: - signOut

    var signOutThrowableError: Error?
    var signOutCallsCount = 0
    var signOutCalled: Bool {
        return signOutCallsCount > 0
    }
    var signOutClosure: (() throws -> Void)?

    func signOut() throws {
        if let error = signOutThrowableError {
            throw error
        }
        signOutCallsCount += 1
        try signOutClosure?()
    }

}
