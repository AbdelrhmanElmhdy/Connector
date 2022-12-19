// Generated using Sourcery 1.9.2 — https://github.com/krzysztofzablocki/Sourcery

import Foundation
import FirebaseCore
import FirebaseFirestore
import CoreData
@testable import Connector

class UserNetworkServiceMock: UserNetworkService {



    //MARK: - setUserData

    var setUserDataUserCallsCount = 0
    var setUserDataUserCalled: Bool {
        return setUserDataUserCallsCount > 0
    }
    var setUserDataUserReceivedUser: User?
    var setUserDataUserReceivedInvocations: [User] = []
    var setUserDataUserClosure: ((User) -> Void)?

    func setUserData(user: User) {
        setUserDataUserCallsCount += 1
        setUserDataUserReceivedUser = user
        setUserDataUserReceivedInvocations.append(user)
        setUserDataUserClosure?(user)
    }

    //MARK: - fetchUser

    var fetchUserWithIdBackgroundMOCCompletionCallsCount = 0
    var fetchUserWithIdBackgroundMOCCompletionCalled: Bool {
        return fetchUserWithIdBackgroundMOCCompletionCallsCount > 0
    }
    var fetchUserWithIdBackgroundMOCCompletionReceivedArguments: (uid: String, backgroundMOC: NSManagedObjectContext, completion: (_ user: User?, _ error: Error?) -> Void)?
    var fetchUserWithIdBackgroundMOCCompletionReceivedInvocations: [(uid: String, backgroundMOC: NSManagedObjectContext, completion: (_ user: User?, _ error: Error?) -> Void)] = []
    var fetchUserWithIdBackgroundMOCCompletionClosure: ((String, NSManagedObjectContext, @escaping (_ user: User?, _ error: Error?) -> Void) -> Void)?

    func fetchUser(withId uid: String, backgroundMOC: NSManagedObjectContext, completion: @escaping (_ user: User?, _ error: Error?) -> Void) {
        fetchUserWithIdBackgroundMOCCompletionCallsCount += 1
        fetchUserWithIdBackgroundMOCCompletionReceivedArguments = (uid: uid, backgroundMOC: backgroundMOC, completion: completion)
        fetchUserWithIdBackgroundMOCCompletionReceivedInvocations.append((uid: uid, backgroundMOC: backgroundMOC, completion: completion))
        fetchUserWithIdBackgroundMOCCompletionClosure?(uid, backgroundMOC, completion)
    }

    //MARK: - searchForUsers

    var searchForUsersWithUsernameSimilarToBackgroundMOCHandlerCallsCount = 0
    var searchForUsersWithUsernameSimilarToBackgroundMOCHandlerCalled: Bool {
        return searchForUsersWithUsernameSimilarToBackgroundMOCHandlerCallsCount > 0
    }
    var searchForUsersWithUsernameSimilarToBackgroundMOCHandlerReceivedArguments: (username: String, backgroundMOC: NSManagedObjectContext, handler: (_ users: [User]?, _ error: Error?) -> Void)?
    var searchForUsersWithUsernameSimilarToBackgroundMOCHandlerReceivedInvocations: [(username: String, backgroundMOC: NSManagedObjectContext, handler: (_ users: [User]?, _ error: Error?) -> Void)] = []
    var searchForUsersWithUsernameSimilarToBackgroundMOCHandlerClosure: ((String, NSManagedObjectContext, @escaping (_ users: [User]?, _ error: Error?) -> Void) -> Void)?

    func searchForUsers(withUsernameSimilarTo username: String, backgroundMOC: NSManagedObjectContext, handler: @escaping (_ users: [User]?, _ error: Error?) -> Void) {
        searchForUsersWithUsernameSimilarToBackgroundMOCHandlerCallsCount += 1
        searchForUsersWithUsernameSimilarToBackgroundMOCHandlerReceivedArguments = (username: username, backgroundMOC: backgroundMOC, handler: handler)
        searchForUsersWithUsernameSimilarToBackgroundMOCHandlerReceivedInvocations.append((username: username, backgroundMOC: backgroundMOC, handler: handler))
        searchForUsersWithUsernameSimilarToBackgroundMOCHandlerClosure?(username, backgroundMOC, handler)
    }

    //MARK: - cancelUserSearch

    var cancelUserSearchCallsCount = 0
    var cancelUserSearchCalled: Bool {
        return cancelUserSearchCallsCount > 0
    }
    var cancelUserSearchClosure: (() -> Void)?

    func cancelUserSearch() {
        cancelUserSearchCallsCount += 1
        cancelUserSearchClosure?()
    }

}
