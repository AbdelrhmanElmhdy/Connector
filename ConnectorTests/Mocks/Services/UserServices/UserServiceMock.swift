// Generated using Sourcery 1.9.2 — https://github.com/krzysztofzablocki/Sourcery

import Foundation
import CoreData
@testable import Connector

class UserServiceMock: UserService {



    //MARK: - createUser

    var createUserCallsCount = 0
    var createUserCalled: Bool {
        return createUserCallsCount > 0
    }
    var createUserReturnValue: User!
    var createUserClosure: (() -> User)?

    func createUser() -> User {
        createUserCallsCount += 1
        if let createUserClosure = createUserClosure {
            return createUserClosure()
        } else {
            return createUserReturnValue
        }
    }

    //MARK: - fetchUser

    var fetchUserWithObjectIDThrowableError: Error?
    var fetchUserWithObjectIDCallsCount = 0
    var fetchUserWithObjectIDCalled: Bool {
        return fetchUserWithObjectIDCallsCount > 0
    }
    var fetchUserWithObjectIDReceivedObjectID: NSManagedObjectID?
    var fetchUserWithObjectIDReceivedInvocations: [NSManagedObjectID] = []
    var fetchUserWithObjectIDReturnValue: User?
    var fetchUserWithObjectIDClosure: ((NSManagedObjectID) throws -> User?)?

    func fetchUser(withObjectID objectID: NSManagedObjectID) throws -> User? {
        if let error = fetchUserWithObjectIDThrowableError {
            throw error
        }
        fetchUserWithObjectIDCallsCount += 1
        fetchUserWithObjectIDReceivedObjectID = objectID
        fetchUserWithObjectIDReceivedInvocations.append(objectID)
        if let fetchUserWithObjectIDClosure = fetchUserWithObjectIDClosure {
            return try fetchUserWithObjectIDClosure(objectID)
        } else {
            return fetchUserWithObjectIDReturnValue
        }
    }

    //MARK: - fetchUsers

    var fetchUsersWithObjectIDsCallsCount = 0
    var fetchUsersWithObjectIDsCalled: Bool {
        return fetchUsersWithObjectIDsCallsCount > 0
    }
    var fetchUsersWithObjectIDsReceivedObjectIDs: [NSManagedObjectID]?
    var fetchUsersWithObjectIDsReceivedInvocations: [[NSManagedObjectID]] = []
    var fetchUsersWithObjectIDsReturnValue: [User]?
    var fetchUsersWithObjectIDsClosure: (([NSManagedObjectID]) -> [User]?)?

    func fetchUsers(withObjectIDs objectIDs: [NSManagedObjectID]) -> [User]? {
        fetchUsersWithObjectIDsCallsCount += 1
        fetchUsersWithObjectIDsReceivedObjectIDs = objectIDs
        fetchUsersWithObjectIDsReceivedInvocations.append(objectIDs)
        if let fetchUsersWithObjectIDsClosure = fetchUsersWithObjectIDsClosure {
            return fetchUsersWithObjectIDsClosure(objectIDs)
        } else {
            return fetchUsersWithObjectIDsReturnValue
        }
    }

    //MARK: - fetchUser

    var fetchUserWithIdCallsCount = 0
    var fetchUserWithIdCalled: Bool {
        return fetchUserWithIdCallsCount > 0
    }
    var fetchUserWithIdReceivedId: String?
    var fetchUserWithIdReceivedInvocations: [String] = []
    var fetchUserWithIdReturnValue: User?
    var fetchUserWithIdClosure: ((String) -> User?)?

    func fetchUser(withId id: String) -> User? {
        fetchUserWithIdCallsCount += 1
        fetchUserWithIdReceivedId = id
        fetchUserWithIdReceivedInvocations.append(id)
        if let fetchUserWithIdClosure = fetchUserWithIdClosure {
            return fetchUserWithIdClosure(id)
        } else {
            return fetchUserWithIdReturnValue
        }
    }

    //MARK: - fetchUser

    var fetchUserWithUsernameCallsCount = 0
    var fetchUserWithUsernameCalled: Bool {
        return fetchUserWithUsernameCallsCount > 0
    }
    var fetchUserWithUsernameReceivedUsername: String?
    var fetchUserWithUsernameReceivedInvocations: [String] = []
    var fetchUserWithUsernameReturnValue: User?
    var fetchUserWithUsernameClosure: ((String) -> User?)?

    func fetchUser(withUsername username: String) -> User? {
        fetchUserWithUsernameCallsCount += 1
        fetchUserWithUsernameReceivedUsername = username
        fetchUserWithUsernameReceivedInvocations.append(username)
        if let fetchUserWithUsernameClosure = fetchUserWithUsernameClosure {
            return fetchUserWithUsernameClosure(username)
        } else {
            return fetchUserWithUsernameReturnValue
        }
    }

    //MARK: - fetchRemoteUser

    var fetchRemoteUserWithIdCompletionCallsCount = 0
    var fetchRemoteUserWithIdCompletionCalled: Bool {
        return fetchRemoteUserWithIdCompletionCallsCount > 0
    }
    var fetchRemoteUserWithIdCompletionReceivedArguments: (uid: String, completion: (_ user: User?, _ error: Error?) -> Void)?
    var fetchRemoteUserWithIdCompletionReceivedInvocations: [(uid: String, completion: (_ user: User?, _ error: Error?) -> Void)] = []
    var fetchRemoteUserWithIdCompletionClosure: ((String, @escaping (_ user: User?, _ error: Error?) -> Void) -> Void)?

    func fetchRemoteUser(withId uid: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void) {
        fetchRemoteUserWithIdCompletionCallsCount += 1
        fetchRemoteUserWithIdCompletionReceivedArguments = (uid: uid, completion: completion)
        fetchRemoteUserWithIdCompletionReceivedInvocations.append((uid: uid, completion: completion))
        fetchRemoteUserWithIdCompletionClosure?(uid, completion)
    }

    //MARK: - setRemoteUserData

    var setRemoteUserDataUserCallsCount = 0
    var setRemoteUserDataUserCalled: Bool {
        return setRemoteUserDataUserCallsCount > 0
    }
    var setRemoteUserDataUserReceivedUser: User?
    var setRemoteUserDataUserReceivedInvocations: [User] = []
    var setRemoteUserDataUserClosure: ((User) -> Void)?

    func setRemoteUserData(user: User) {
        setRemoteUserDataUserCallsCount += 1
        setRemoteUserDataUserReceivedUser = user
        setRemoteUserDataUserReceivedInvocations.append(user)
        setRemoteUserDataUserClosure?(user)
    }

    //MARK: - getCurrentUser

    var getCurrentUserThrowableError: Error?
    var getCurrentUserCallsCount = 0
    var getCurrentUserCalled: Bool {
        return getCurrentUserCallsCount > 0
    }
    var getCurrentUserReturnValue: User!
    var getCurrentUserClosure: (() throws -> User)?

    func getCurrentUser() throws -> User {
        if let error = getCurrentUserThrowableError {
            throw error
        }
        getCurrentUserCallsCount += 1
        if let getCurrentUserClosure = getCurrentUserClosure {
            return try getCurrentUserClosure()
        } else {
            return getCurrentUserReturnValue
        }
    }

    //MARK: - deleteUser

    var deleteUserUsernameCallsCount = 0
    var deleteUserUsernameCalled: Bool {
        return deleteUserUsernameCallsCount > 0
    }
    var deleteUserUsernameReceivedUsername: String?
    var deleteUserUsernameReceivedInvocations: [String] = []
    var deleteUserUsernameClosure: ((String) -> Void)?

    func deleteUser(username: String) {
        deleteUserUsernameCallsCount += 1
        deleteUserUsernameReceivedUsername = username
        deleteUserUsernameReceivedInvocations.append(username)
        deleteUserUsernameClosure?(username)
    }

    //MARK: - searchForRemoteUsers

    var searchForRemoteUsersWithUsernameSimilarToHandlerCallsCount = 0
    var searchForRemoteUsersWithUsernameSimilarToHandlerCalled: Bool {
        return searchForRemoteUsersWithUsernameSimilarToHandlerCallsCount > 0
    }
    var searchForRemoteUsersWithUsernameSimilarToHandlerReceivedArguments: (username: String, handler: (_ users: [User]?, _ error: Error?) -> Void)?
    var searchForRemoteUsersWithUsernameSimilarToHandlerReceivedInvocations: [(username: String, handler: (_ users: [User]?, _ error: Error?) -> Void)] = []
    var searchForRemoteUsersWithUsernameSimilarToHandlerClosure: ((String, @escaping (_ users: [User]?, _ error: Error?) -> Void) -> Void)?

    func searchForRemoteUsers(withUsernameSimilarTo username: String, handler: @escaping (_ users: [User]?, _ error: Error?) -> Void) {
        searchForRemoteUsersWithUsernameSimilarToHandlerCallsCount += 1
        searchForRemoteUsersWithUsernameSimilarToHandlerReceivedArguments = (username: username, handler: handler)
        searchForRemoteUsersWithUsernameSimilarToHandlerReceivedInvocations.append((username: username, handler: handler))
        searchForRemoteUsersWithUsernameSimilarToHandlerClosure?(username, handler)
    }

    //MARK: - prepareToMoveUsersToDifferentThread

    var prepareToMoveUsersToDifferentThreadThrowableError: Error?
    var prepareToMoveUsersToDifferentThreadCallsCount = 0
    var prepareToMoveUsersToDifferentThreadCalled: Bool {
        return prepareToMoveUsersToDifferentThreadCallsCount > 0
    }
    var prepareToMoveUsersToDifferentThreadReceivedObjects: [User]?
    var prepareToMoveUsersToDifferentThreadReceivedInvocations: [[User]] = []
    var prepareToMoveUsersToDifferentThreadReturnValue: [NSManagedObjectID]!
    var prepareToMoveUsersToDifferentThreadClosure: (([User]) throws -> [NSManagedObjectID])?

    func prepareToMoveUsersToDifferentThread(_ objects: [User]) throws -> [NSManagedObjectID] {
        if let error = prepareToMoveUsersToDifferentThreadThrowableError {
            throw error
        }
        prepareToMoveUsersToDifferentThreadCallsCount += 1
        prepareToMoveUsersToDifferentThreadReceivedObjects = objects
        prepareToMoveUsersToDifferentThreadReceivedInvocations.append(objects)
        if let prepareToMoveUsersToDifferentThreadClosure = prepareToMoveUsersToDifferentThreadClosure {
            return try prepareToMoveUsersToDifferentThreadClosure(objects)
        } else {
            return prepareToMoveUsersToDifferentThreadReturnValue
        }
    }

}
