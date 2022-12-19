// Generated using Sourcery 1.9.2 — https://github.com/krzysztofzablocki/Sourcery

import Foundation
@testable import Connector

class AuthNetworkServiceMock: AuthNetworkService {
    
    //MARK: - login

    var loginEmailPasswordCompletionCallsCount = 0
    var loginEmailPasswordCompletionCalled: Bool {
        return loginEmailPasswordCompletionCallsCount > 0
    }
    var loginEmailPasswordCompletionReceivedArguments: (email: String, password: String, completion: (_ userID: String?, FirebaseAuthError?) -> Void)?
    var loginEmailPasswordCompletionReceivedInvocations: [(email: String, password: String, completion: (_ userID: String?, FirebaseAuthError?) -> Void)] = []
    var loginEmailPasswordCompletionClosure: ((String, String, @escaping (_ userID: String?, FirebaseAuthError?) -> Void) -> Void)?

    func login(email: String, password: String, completion: @escaping (_ userID: String?, FirebaseAuthError?) -> Void) {
        loginEmailPasswordCompletionCallsCount += 1
        loginEmailPasswordCompletionReceivedArguments = (email: email, password: password, completion: completion)
        loginEmailPasswordCompletionReceivedInvocations.append((email: email, password: password, completion: completion))
        loginEmailPasswordCompletionClosure?(email, password, completion)
    }

    //MARK: - signup

    var signupUserPasswordCompletionCallsCount = 0
    var signupUserPasswordCompletionCalled: Bool {
        return signupUserPasswordCompletionCallsCount > 0
    }
    var signupUserPasswordCompletionReceivedArguments: (user: User, password: String, completion: (_ userID: String?, FirebaseAuthError?) -> Void)?
    var signupUserPasswordCompletionReceivedInvocations: [(user: User, password: String, completion: (_ userID: String?, FirebaseAuthError?) -> Void)] = []
    var signupUserPasswordCompletionClosure: ((User, String, @escaping (_ userID: String?, FirebaseAuthError?) -> Void) -> Void)?

    func signup(user: User, password: String, completion: @escaping (_ userID: String?, FirebaseAuthError?) -> Void) {
        signupUserPasswordCompletionCallsCount += 1
        signupUserPasswordCompletionReceivedArguments = (user: user, password: password, completion: completion)
        signupUserPasswordCompletionReceivedInvocations.append((user: user, password: password, completion: completion))
        signupUserPasswordCompletionClosure?(user, password, completion)
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
